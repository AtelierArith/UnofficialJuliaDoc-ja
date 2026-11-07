```julia
LinearAlgebra.uplo(S::Union{Symmetric, Hermitian})::Symbol
```

行列 `S` の格納された三角部分（`:U` または `:L`）に対応する `Symbol` を返します。つまり、その三角部分について、`S` と `parent(S)` の両方に共通する要素です。

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
