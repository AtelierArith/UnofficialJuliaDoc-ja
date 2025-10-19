```julia
AbstractWorkerPool
```

Supertype for worker pools such as [`WorkerPool`](@ref) and [`CachingPool`](@ref). An `AbstractWorkerPool` should implement:

  * [`push!`](@ref) - add a new worker to the overall pool (available + busy)
  * [`put!`](@ref) - put back a worker to the available pool
  * [`take!`](@ref) - take a worker from the available pool (to be used for remote function execution)
  * [`wait`](@ref) - block until a worker is available
  * [`length`](@ref) - number of workers available in the overall pool
  * [`isready`](@ref) - return false if a `take!` on the pool would block, else true

The default implementations of the above (on a `AbstractWorkerPool`) require fields

  * `channel::Channel{Int}`
  * `workers::Set{Int}`

where `channel` contains free worker pids and `workers` is the set of all workers associated with this pool.
