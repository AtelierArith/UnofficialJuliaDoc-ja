```julia
Sys.cpu_info()
```

Return a vector of `CPUinfo` objects, where each object represents information about a CPU core.

This is pretty-printed in a tabular format by `Sys.cpu_summary`, which is included in the output of `versioninfo(verbose=true)`, so most users will not need to access the `CPUinfo` data structures directly.

The function provides information about each CPU, including model, speed, and usage statistics such as user time, nice time, system time, idle time, and interrupt time.
