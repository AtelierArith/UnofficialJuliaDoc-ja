```julia
Base.Experimental.task_running_time_ns(t::Task) -> Union{UInt64, Nothing}
```

タスク `t` が実行に費やした合計ナノ秒を返します。このメトリックは、`t` が yield するか完了するまで更新されず、`t` が現在のタスクである場合は継続的に更新されます。詳細は [`Base.Experimental.task_wall_time_ns`](@ref) を参照してください。

タスクのタイミングが有効でない場合は `nothing` を返します。詳細は [`Base.Experimental.task_metrics`](@ref) を参照してください。

!!! note "このメトリックは Julia スケジューラからのものです"
    タスクは OS スレッド上で実行されており、OS スケジューラによってスケジュール解除される場合、この時間もメトリックにカウントされます。


!!! compat "Julia 1.12"
    このメソッドは Julia 1.12 で追加されました。

