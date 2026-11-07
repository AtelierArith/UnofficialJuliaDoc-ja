```julia
AtomicMemory{T} == GenericMemory{:atomic, T, Core.CPU}
```

Fixed-size [`DenseVector{T}`](@ref DenseVector). Fetching of any of its individual elements is performed atomically (with `:monotonic` ordering by default).

!!! warning
    The access to `AtomicMemory` must be done by either using the [`@atomic`](@ref) macro or the lower level interface functions: `Base.getindex_atomic`, `Base.setindex_atomic!`, `Base.setindexonce_atomic!`, `Base.swapindex_atomic!`, `Base.modifyindex_atomic!`, and `Base.replaceindex_atomic!`.


For details, see [Atomic Operations](@ref man-atomic-operations) as well as macros [`@atomic`](@ref), [`@atomiconce`](@ref), [`@atomicswap`](@ref), and [`@atomicreplace`](@ref).

!!! compat "Julia 1.11"
    This type requires Julia 1.11 or later.


!!! compat "Julia 1.12"
    Lower level interface functions or `@atomic` macro requires Julia 1.12 or later.

