```julia
ftranspose!(X::AbstractSparseMatrixCSC{Tv,Ti}, A::AbstractSparseMatrixCSC{Tv,Ti}, f::Function) where {Tv,Ti}
```

Transpose `A` and store it in `X` while applying the function `f` to the non-zero elements. Does not remove the zeros created by `f`. `size(X)` must be equal to `size(transpose(A))`. No additional memory is allocated other than resizing the rowval and nzval of `X`, if needed.

See `halfperm!`
