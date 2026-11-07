```julia
PaddedSpinLock() <: AbstractSpinLock
```

PaddedSpinLocks are padded so that each is guaranteed to be on its own cache line, to avoid false sharing. See also [`SpinLock`](@ref).

See the documentation for [`AbstractSpinLock`](@ref) regarding correct usage.

!!! compat "Julia 1.13"
    This type requires at least Julia 1.13.

