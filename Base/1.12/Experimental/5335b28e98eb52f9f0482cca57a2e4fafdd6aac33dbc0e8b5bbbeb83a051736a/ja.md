```julia
Base.Experimental.task_metrics(::Bool)
```

タスクごとのメトリクスの収集を有効または無効にします。`Base.Experimental.task_metrics(true)`が有効なときに作成された`Task`は、[`Base.Experimental.task_running_time_ns`](@ref)および[`Base.Experimental.task_wall_time_ns`](@ref)のタイミング情報を利用できます。

!!! note
    タスクメトリクスは、`--task-metrics=yes`コマンドラインオプションを介して起動時に有効にすることができます。

