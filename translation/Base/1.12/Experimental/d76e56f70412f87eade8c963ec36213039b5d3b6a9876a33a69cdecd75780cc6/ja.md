```julia
Base.Experimental.task_wall_time_ns(t::Task) -> Union{UInt64, Nothing}
```

タスク `t` が実行可能であった合計ナノ秒を返します。これは、タスクが最初に実行キューに入ってから、完了するまでの時間、またはタスクがまだ完了していない場合は現在の時間までの時間です。 [`Base.Experimental.task_running_time_ns`](@ref) も参照してください。

タスクのタイミングが有効でない場合は `nothing` を返します。 [`Base.Experimental.task_metrics`](@ref) も参照してください。

!!! compat "Julia 1.12"
    このメソッドは Julia 1.12 で追加されました。

