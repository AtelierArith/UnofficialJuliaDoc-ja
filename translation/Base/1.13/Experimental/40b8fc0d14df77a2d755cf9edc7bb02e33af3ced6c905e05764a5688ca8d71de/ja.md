```julia
Base.Experimental.task_metrics(::Bool)
```

タスクごとのメトリクス収集を有効または無効にします。`Task` は、`Base.Experimental.task_metrics(true)` が有効な状態で作成されると、[`Base.Experimental.task_running_time_ns`](@ref) と [`Base.Experimental.task_wall_time_ns`](@ref) のタイミング情報を利用できます。

!!! note
    起動時に `--task-metrics=yes` コマンドラインオプションを指定すると、タスクメトリクスを有効にできます。

