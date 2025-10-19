```julia
Base.Experimental.task_wall_time_ns(t::Task) -> Union{UInt64, Nothing}
```

Return the total nanoseconds that the task `t` was runnable. This is the time since the task first entered the run queue until the time at which it completed, or until the current time if the task has not yet completed. See also [`Base.Experimental.task_running_time_ns`](@ref).

Returns `nothing` if task timings are not enabled. See [`Base.Experimental.task_metrics`](@ref).

!!! compat "Julia 1.12"
    This method was added in Julia 1.12.

