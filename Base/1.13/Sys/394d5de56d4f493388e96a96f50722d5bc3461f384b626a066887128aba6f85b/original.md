```julia
Sys.cpu_summary(io::IO=stdout, cpu::AbstractVector{CPUinfo}=cpu_info())
```

Print a summary of CPU information to the `io` stream (defaulting to [`stdout`](@ref)), organizing and displaying aggregated data for CPUs with the same model, for a given array of `CPUinfo` data structures describing a set of CPUs (which defaults to the return value of the [`Sys.cpu_info`](@ref) function).

The summary includes aggregated information for each distinct CPU model, providing details such as average CPU speed and total time spent in different modes (user, nice, sys, idle, irq) across all cores with the same model.

Note: Included in the detailed system information via `versioninfo(verbose=true)`.
