```
*(A, B::AbstractMatrix, C)
A * B * C * D
```

Chained multiplication of 3 or 4 matrices is done in the most efficient sequence, based on the sizes of the arrays. That is, the number of scalar multiplications needed for `(A * B) * C` (with 3 dense matrices) is compared to that for `A * (B * C)` to choose which of these to execute.

If the last factor is a vector, or the first a transposed vector, then it is efficient to deal with these first. In particular `x' * B * y` means `(x' * B) * y` for an ordinary column-major `B::Matrix`. Unlike `dot(x, B, y)`, this allocates an intermediate array.

If the first or last factor is a number, this will be fused with the matrix multiplication, using 5-arg [`mul!`](@ref).

See also [`muladd`](@ref), [`dot`](@ref).

!!! compat "Julia 1.7"
    These optimisations require at least Julia 1.7.

