```julia
Base.Experimental.task_metrics(::Bool)
```

Enable or disable the collection of per-task metrics. A `Task` created when `Base.Experimental.task_metrics(true)` is in effect will have [`Base.Experimental.task_running_time_ns`](@ref) and [`Base.Experimental.task_wall_time_ns`](@ref) timing information available.

!!! note
    Task metrics can be enabled at start-up via the `--task-metrics=yes` command line option.

