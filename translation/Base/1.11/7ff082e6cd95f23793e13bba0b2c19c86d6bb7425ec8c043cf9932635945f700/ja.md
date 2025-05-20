```
schedule(t::Task, [val]; error=false)
```

スケジューラのキューに [`Task`](@ref) を追加します。これにより、タスクはシステムがアイドル状態のときに常に実行されますが、タスクが [`wait`](@ref) のようなブロッキング操作を行う場合は除きます。

第二引数 `val` が提供されると、タスクが再び実行されるときに（[`yieldto`](@ref) の戻り値を介して）タスクに渡されます。`error` が `true` の場合、値は起こされたタスクで例外として発生します。

!!! warning
    開始された任意の `Task` に対して `schedule` を使用するのは不正です。詳細については [the API reference](@ref low-level-schedule-wait) を参照してください。


!!! warning
    デフォルトでは、タスクには sticky ビットが true `t.sticky` に設定されます。これは [`@async`](@ref) の歴史的なデフォルトをモデル化しています。Sticky タスクは、最初にスケジュールされたワーカースレッドでのみ実行でき、スケジュールされると、スケジュール元のタスクも sticky になります。 [`Threads.@spawn`](@ref) の動作を得るには、sticky ビットを手動で `false` に設定してください。


# 例

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
