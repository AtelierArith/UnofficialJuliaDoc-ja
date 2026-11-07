```julia
Experimental.@sync
```

Wait until all lexically-enclosed uses of [`@async`](@ref), [`@spawn`](@ref Threads.@spawn), `Distributed.@spawnat` and `Distributed.@distributed` are complete, or at least one of them has errored. The first exception is immediately rethrown. It is the responsibility of the user to cancel any still-running operations during error handling.

!!! Note     This is different to [`@sync`](@ref) in that errors from wrapped tasks are thrown immediately,     potentially before all tasks have returned.

!!! Note     This interface is experimental and subject to change or removal without notice.
