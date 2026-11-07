```julia
SpinLock() <: AbstractSpinLock
```

Spinlocks are not padded, and so may suffer from false sharing. See also [`PaddedSpinLock`](@ref).

See the documentation for [`AbstractSpinLock`](@ref) regarding correct usage.
