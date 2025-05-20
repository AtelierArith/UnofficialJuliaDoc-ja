```
RowNonZero
```

First non-zero element in the remaining rows is chosen as the pivot element.

Beware that for floating-point matrices, the resulting LU algorithm is numerically unstable — this strategy is mainly useful for comparison to hand calculations (which typically use this strategy) or for other algebraic types (e.g. rational numbers) not susceptible to roundoff errors.   Otherwise, the default `RowMaximum` pivoting strategy should be generally preferred in Gaussian elimination.

Note that the [element type](@ref eltype) of the matrix must admit an [`iszero`](@ref) method.
