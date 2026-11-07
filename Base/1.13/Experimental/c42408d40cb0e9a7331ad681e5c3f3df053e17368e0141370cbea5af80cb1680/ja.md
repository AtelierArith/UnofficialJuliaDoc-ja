```julia
Base.Experimental.task_running_time_ns(t::Task)::Union{UInt64, Nothing}
```

タスク `t` の実行時間の合計をナノ秒単位で返します。このメトリクスは、`t` が yield するか完了したときにのみ更新されます。ただし、現在のタスクが `t` の場合は、継続的に更新されます。[`Base.Experimental.task_wall_time_ns`](@ref) も参照してください。

タスクの実行時間計測が有効でない場合は、`nothing` を返します。[`Base.Experimental.task_metrics`](@ref) も参照してください。

!!! note "このメトリクスは Julia スケジューラによるものです"
    OS スケジューラによって OS スレッドの実行が中断されている間も、その時間はこのメトリクスに含まれます。


!!! compat "Julia 1.12"
    このメソッドは Julia 1.12 で追加されました。

