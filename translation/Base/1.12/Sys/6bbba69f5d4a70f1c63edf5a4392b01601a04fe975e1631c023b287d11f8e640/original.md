```julia
Sys.CPU_THREADS::Int
```

The number of logical CPU cores available in the system, i.e. the number of threads that the CPU can run concurrently. Note that this is not necessarily the number of CPU cores, for example, in the presence of [hyper-threading](https://en.wikipedia.org/wiki/Hyper-threading).

See Hwloc.jl or CpuId.jl for extended information, including number of physical cores.
