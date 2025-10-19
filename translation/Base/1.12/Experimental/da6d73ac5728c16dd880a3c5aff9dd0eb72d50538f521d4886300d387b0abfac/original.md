```julia
Base.Experimental.task_running_time_ns(t::Task) -> Union{UInt64, Nothing}
```

Return the total nanoseconds that the task `t` has spent running. This metric is only updated when `t` yields or completes unless `t` is the current task, in which it will be updated continuously. See also [`Base.Experimental.task_wall_time_ns`](@ref).

Returns `nothing` if task timings are not enabled. See [`Base.Experimental.task_metrics`](@ref).

!!! note "This metric is from the Julia scheduler"
    A task may be running on an OS thread that is descheduled by the OS scheduler, this time still counts towards the metric.


!!! compat "Julia 1.12"
    This method was added in Julia 1.12.

