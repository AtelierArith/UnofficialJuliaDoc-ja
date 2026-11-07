```julia
Sys.EFFECTIVE_CPU_THREADS::Int
```

The effective number of logical CPU cores available to the Julia process, taking into account container limits (e.g., Docker `--cpus`, Kubernetes CPU limits, cgroup quotas). This is the minimum of the hardware CPU thread count and any imposed CPU limits.

In non-containerized environments, this typically equals `Sys.CPU_THREADS`. In containerized environments, it respects cgroup CPU limits and provides a more accurate measure of available parallelism.

Use this constant when determining default thread pool sizes or parallelism levels to ensure proper behavior in containerized deployments.
