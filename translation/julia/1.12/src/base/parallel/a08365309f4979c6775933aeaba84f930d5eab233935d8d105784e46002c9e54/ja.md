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

[`schedule`](@ref)の最も簡単で正しい使用法は、まだ開始されていない（スケジュールされた）`Task`上で行うことです。しかし、`4d61726b646f776e2e436f64652822222c20227363686564756c652229_40726566`と[`wait`](@ref)を、同期インターフェースを構築するための非常に低レベルのビルディングブロックとして使用することも可能です。`schedule(task)`を呼び出すための重要な前提条件は、呼び出し元が`task`を「所有」している必要があることです。つまり、`schedule(task)`を呼び出すコードが、指定された`task`内で`wait`が発生する場所を知っている必要があります。このような前提条件を確保するための戦略の一つは、以下の例で示されているようにアトミックを使用することです。

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

`OneWayEvent`は、1つのタスクが別のタスクの`notify`を`wait`することを可能にします。これは、`wait`が単一のタスクから1回しか使用できないため、制限された通信インターフェースです（`ev.task`の非原子的な割り当てに注意してください）。

この例では、`notify(ev::OneWayEvent)`は、*それ*が状態を`OWE_WAITING`から`OWE_NOTIFYING`に変更する場合に限り、`schedule(ev.task)`を呼び出すことが許可されています。これにより、`wait(ev::OneWayEvent)`を実行しているタスクが現在`ok`ブランチにあり、他のタスクが`schedule(ev.task)`を試みることはできないことがわかります。なぜなら、それらの`@atomicreplace(ev.state, state => OWE_NOTIFYING)`は失敗するからです。
