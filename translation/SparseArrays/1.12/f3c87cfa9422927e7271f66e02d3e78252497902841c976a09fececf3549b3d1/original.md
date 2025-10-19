```julia
halfperm!(X::AbstractSparseMatrixCSC{Tv,Ti}, A::AbstractSparseMatrixCSC{TvA,Ti},
          q::AbstractVector{<:Integer}, f::Function = identity) where {Tv,TvA,Ti}
```

Column-permute and transpose `A`, simultaneously applying `f` to each entry of `A`, storing the result `(f(A)Q)^T` (`map(f, transpose(A[:,q]))`) in `X`.

Element type `Tv` of `X` must match `f(::TvA)`, where `TvA` is the element type of `A`. `X`'s dimensions must match those of `transpose(A)` (`size(X, 1) == size(A, 2)` and `size(X, 2) == size(A, 1)`), and `X` must have enough storage to accommodate all allocated entries in `A` (`length(rowvals(X)) >= nnz(A)` and `length(nonzeros(X)) >= nnz(A)`). Column-permutation `q`'s length must match `A`'s column count (`length(q) == size(A, 2)`).

This method is the parent of several methods performing transposition and permutation operations on [`SparseMatrixCSC`](@ref)s. As this method performs no argument checking, prefer the safer child methods (`[c]transpose[!]`, `permute[!]`) to direct use.

This method implements the `HALFPERM` algorithm described in F. Gustavson, "Two fast algorithms for sparse matrices: multiplication and permuted transposition," ACM TOMS 4(3), 250-269 (1978). The algorithm runs in `O(size(A, 1), size(A, 2), nnz(A))` time and requires no space beyond that passed in.
