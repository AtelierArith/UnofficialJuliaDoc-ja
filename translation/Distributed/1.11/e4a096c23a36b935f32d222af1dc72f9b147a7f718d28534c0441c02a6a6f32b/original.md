```julia
rmprocs(pids...; waitfor=typemax(Int))
```

Remove the specified workers. Note that only process 1 can add or remove workers.

Argument `waitfor` specifies how long to wait for the workers to shut down:

  * If unspecified, `rmprocs` will wait until all requested `pids` are removed.
  * An [`ErrorException`](@ref) is raised if all workers cannot be terminated before the requested `waitfor` seconds.
  * With a `waitfor` value of 0, the call returns immediately with the workers scheduled for removal in a different task. The scheduled [`Task`](@ref) object is returned. The user should call [`wait`](@ref) on the task before invoking any other parallel calls.

# Examples

```julia-repl
$ julia -p 5

julia> t = rmprocs(2, 3, waitfor=0)
Task (runnable) @0x0000000107c718d0

julia> wait(t)

julia> workers()
3-element Array{Int64,1}:
 4
 5
 6
```
