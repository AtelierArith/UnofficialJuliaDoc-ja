# Tasks

```@docs
Core.Task
Base.@task
Base.@async
Base.asyncmap
Base.asyncmap!
Base.current_task
Base.istaskdone
Base.istaskstarted
Base.istaskfailed
Base.task_local_storage(::Any)
Base.task_local_storage(::Any, ::Any)
Base.task_local_storage(::Function, ::Any, ::Any)
Core.ConcurrencyViolationError
```

## Scheduling

```@docs
Base.yield
Base.yieldto
Base.sleep
Base.schedule
```

## [Synchronization](@id lib-task-sync)

```@docs
Base.errormonitor
Base.@sync
Base.wait
Base.waitany
Base.waitall
Base.fetch(t::Task)
Base.fetch(x::Any)
Base.timedwait

Base.Condition
Base.Threads.Condition
Base.Threads.Event
Base.notify
Base.reset(::Base.Threads.Event)

Base.Semaphore
Base.acquire
Base.@acquire
Base.release

Base.AbstractLock
Base.lock
Base.unlock
Base.trylock
Base.islocked
Base.ReentrantLock
Base.@lock
Base.Lockable
```

## Channels

```@docs
Base.AbstractChannel
Base.Channel
Base.Channel(::Function)
Base.put!(::Channel, ::Any)
Base.take!(::Channel)
Base.isfull(::Channel)
Base.isready(::Channel)
Base.isopen(::Channel)
Base.fetch(::Channel)
Base.close(::Channel)
Base.bind(c::Channel, task::Task)
```

## [Low-level synchronization using `schedule` and `wait`](@id low-level-schedule-wait)

[`schedule`](@ref)を正しく使う最も簡単な方法は、まだ開始（スケジュール）されていない`Task`に対して使うことです。ただし、[`schedule`](@ref)と[`wait`](@ref)を、同期インターフェースを構築するための非常に低レベルな構成要素として使うこともできます。`schedule(task)`を呼び出す際の重要な前提条件は、呼び出し元が`task`を「所有」していることです。つまり、指定された`task`内で`wait`を呼び出す箇所が、`schedule(task)`を呼び出すコードにとって既知である必要があります。この前提条件を確実に満たす方法の一つは、次の例のようにアトミック操作を使うことです。

```jldoctest
@enum OWEState begin
    OWE_EMPTY
    OWE_WAITING
    OWE_NOTIFYING
end

mutable struct OneWayEvent
    @atomic state::OWEState
    task::Task
    OneWayEvent() = new(OWE_EMPTY)
end

function Base.notify(ev::OneWayEvent)
    state = @atomic ev.state
    while state !== OWE_NOTIFYING
        # Spin until we successfully update the state to OWE_NOTIFYING:
        state, ok = @atomicreplace(ev.state, state => OWE_NOTIFYING)
        if ok
            if state == OWE_WAITING
                # OWE_WAITING -> OWE_NOTIFYING transition means that the waiter task is
                # already waiting or about to call `wait`. The notifier task must wake up
                # the waiter task.
                schedule(ev.task)
            else
                @assert state == OWE_EMPTY
                # Since we are assuming that there is only one notifier task (for
                # simplicity), we know that the other possible case here is OWE_EMPTY.
                # We do not need to do anything because we know that the waiter task has
                # not called `wait(ev::OneWayEvent)` yet.
            end
            break
        end
    end
    return
end

function Base.wait(ev::OneWayEvent)
    ev.task = current_task()
    state, ok = @atomicreplace(ev.state, OWE_EMPTY => OWE_WAITING)
    if ok
        # OWE_EMPTY -> OWE_WAITING transition means that the notifier task is guaranteed to
        # invoke OWE_WAITING -> OWE_NOTIFYING transition. The waiter task must call
        # `wait()` immediately. In particular, it MUST NOT invoke any function that may
        # yield to the scheduler at this point in code.
        wait()
    else
        @assert state == OWE_NOTIFYING
        # Otherwise, the `state` must have already been moved to OWE_NOTIFYING by the
        # notifier task.
    end
    return
end

ev = OneWayEvent()
@sync begin
    Threads.@spawn begin
        wait(ev)
        println("done")
    end
    println("notifying...")
    notify(ev)
end

# output
notifying...
done
```

`OneWayEvent`を使うと、あるタスクが別のタスクの`notify`に対して`wait`できます。`wait`は単一のタスクから一度しか使えないため、これは制限のある通信インターフェースです（`ev.task`への代入がアトミックではない点に注意してください）。

この例では、`notify(ev::OneWayEvent)`が`schedule(ev.task)`を呼び出せるのは、*それ自身*が状態を`OWE_WAITING`から`OWE_NOTIFYING`に変更した場合に限られます。これにより、`wait(ev::OneWayEvent)`を実行しているタスクが現在`ok`分岐にいることが分かります。また、ほかのタスクが`schedule(ev.task)`を試みることはありません。そうしたタスクの`@atomicreplace(ev.state, state => OWE_NOTIFYING)`は失敗するためです。
