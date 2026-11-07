```julia
LinearAlgebra.uplo(S::Union{Symmetric, Hermitian})::Symbol
```

行列 `S` において、格納されている三角部分（`:U` または `:L`）に対応する `Symbol` を返します。つまり、その三角部分について、`S` と `parent(S)` に共通する要素を返します。

# Example

```jldoctest
julia> S = Symmetric([1 2; 3 4], :U)
2×2 Symmetric{Int64, Matrix{Int64}}:
 1  2
 2  4

julia> LinearAlgebra.uplo(S)
:U

julia> H = Hermitian([1 2; 3 4], :L)
2×2 Hermitian{Int64, Matrix{Int64}}:
 1  3
 3  4

julia> LinearAlgebra.uplo(H)
:L
```
