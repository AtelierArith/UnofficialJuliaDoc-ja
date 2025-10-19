```julia
@inbounds(blk)
```

Eliminates array bounds checking within expressions.

In the example below the in-range check for referencing element `i` of array `A` is skipped to improve performance.

```julia
function sum(A::AbstractArray)
    r = zero(eltype(A))
    for i in eachindex(A)
        @inbounds r += A[i]
    end
    return r
end
```

!!! warning
    Using `@inbounds` may return incorrect results/crashes/corruption for out-of-bounds indices. The user is responsible for checking it manually. Only use `@inbounds` when you are certain that all accesses are in bounds (as undefined behavior, e.g. crashes, might occur if this assertion is violated). For example, using `1:length(A)` instead of `eachindex(A)` in a function like the one above is *not* safely inbounds because the first index of `A` may not be `1` for all user defined types that subtype `AbstractArray`.

