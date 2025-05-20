```
unchecked_noalias_permute!(X::AbstractSparseMatrixCSC{Tv,Ti},
    A::AbstractSparseMatrixCSC{Tv,Ti}, p::AbstractVector{<:Integer},
    q::AbstractVector{<:Integer}, C::AbstractSparseMatrixCSC{Tv,Ti}) where {Tv,Ti}
```

See [`permute!`](@ref) for basic usage. Parent of `permute[!]` methods operating on `SparseMatrixCSC`s that assume none of `X`, `A`, and `C` alias each other. As this method performs no argument checking, prefer the safer child methods (`permute[!]`) to direct use.

This method consists of two major steps: (1) Column-permute (`Q`,`I[:,q]`) and transpose `A` to generate intermediate result `(AQ)^T` (`transpose(A[:,q])`) in `C`. (2) Column-permute (`P^T`, I[:,p]) and transpose intermediate result `(AQ)^T` to generate result `((AQ)^T P^T)^T = PAQ` (`A[p,q]`) in `X`.

The first step is a call to `halfperm!`, and the second is a variant on `halfperm!` that avoids an unnecessary length-`nnz(A)` array-sweep and associated recomputation of column pointers. See [`halfperm!`](:func:SparseArrays.halfperm!) for additional algorithmic information.

See also `unchecked_aliasing_permute!`.
