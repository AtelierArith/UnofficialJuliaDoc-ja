```julia
Base.Experimental.task_wall_time_ns(t::Task)::Union{UInt64, Nothing}
```

タスク `t` が実行可能だった合計時間をナノ秒単位で返します。これは、タスクが初めて実行キューに入ってから完了するまでの時間です。タスクがまだ完了していない場合は、現在までの時間を返します。[`Base.Experimental.task_running_time_ns`](@ref) も参照してください。

タスクのタイミング計測が有効になっていない場合は、`nothing` を返します。[`Base.Experimental.task_metrics`](@ref) を参照してください。

!!! compat "Julia 1.12"
    このメソッドは Julia 1.12 で追加されました。

