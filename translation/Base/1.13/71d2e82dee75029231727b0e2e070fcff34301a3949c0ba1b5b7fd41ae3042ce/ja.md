```julia
schedule(t::Task, [val]; error=false)
```

[`Task`](@ref) をスケジューラのキューに追加します。これにより、システムがほかの処理を行っていない間、タスクは常に実行されます。ただし、[`wait`](@ref) のようなブロッキング操作をタスクが実行する場合は除きます。

2 番目の引数 `val` が指定されている場合、タスクが再び実行されるときに、その引数が（[`yieldto`](@ref) の戻り値を介して）タスクに渡されます。`error` が `true` の場合、その値は起床したタスク内で例外として送出されます。

!!! warning
    すでに開始されている任意の `Task` に対して `schedule` を使用するのは誤りです。詳しくは [the API reference](@ref low-level-schedule-wait) を参照してください。


!!! warning
    デフォルトでは、タスクの sticky bit は true `t.sticky` に設定されます。これは、[`@async`](@ref) の従来のデフォルト動作を再現するものです。sticky タスクは、最初にスケジュールされたワーカースレッドでのみ実行できます。また、スケジュールされると、そのタスクをスケジュールしたタスクも sticky になります。[`Threads.@spawn`](@ref) の動作にするには、sticky bit を手動で `false` に設定してください。


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
