```julia
schedule(t::Task, [val]; error=false)
```

スケジューラのキューに[`Task`](@ref)を追加します。これにより、システムがほかの処理をしていない間、タスクは常に実行されます。ただし、タスクが[`wait`](@ref)のようなブロッキング操作を行う場合は除きます。

2つ目の引数として`val`を指定すると、タスクが再び実行される際に、その値が[`yieldto`](@ref)の戻り値を介してタスクに渡されます。`error`が`true`の場合、その値は起床したタスク内で例外として送出されます。

!!! warning
    すでに開始されている任意の`Task`に対して`schedule`を使用するのは誤りです。詳しくは[the API reference](@ref low-level-schedule-wait)を参照してください。


!!! warning
    デフォルトでは、タスクのstickyビットはtrue `t.sticky`に設定されます。これは、[`@async`](@ref)における従来のデフォルト動作を再現するものです。stickyタスクは、最初にスケジュールされたワーカースレッドでのみ実行できます。また、スケジュールされると、そのタスクをスケジュールした側のタスクもstickyになります。[`Threads.@spawn`](@ref)の動作にするには、stickyビットを手動で`false`に設定してください。


# Examples

```jldoctest
julia> a5() = sum(i for i in 1:1000);

julia> b = Task(a5);

julia> istaskstarted(b)
false

julia> schedule(b);

julia> yield();

julia> istaskstarted(b)
true

julia> istaskdone(b)
true
```
