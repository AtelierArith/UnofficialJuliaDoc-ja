```julia
permutedims(v::AbstractVector)
```

ベクトル `v` を `1 × length(v)` の行列に変換します。[`transpose`](@ref) と異なり、この操作は再帰的ではありません。そのため、数値以外の値を含む配列に特に便利です（再帰的な `transpose` ではエラーが発生する場合があります）。

# Examples

`transpose` とは異なり、`permutedims` は、文字列など、任意の数値以外の要素を含むベクトルにも使用できます。

```jldoctest
julia> permutedims(["a", "b", "c"])
1×3 Matrix{String}:
 "a"  "b"  "c"
```

数値のベクトルに対しては、`permutedims(v)` は `transpose(v)` とほぼ同じように動作しますが、戻り値の型が異なります（`LinearAlgebra.Transpose` のビューではなく、[`reshape`](@ref) を使用します。ただし、どちらも元の配列 `v` とメモリを共有します）。

```jldoctest; setup = :(using LinearAlgebra)
julia> v = [1, 2, 3, 4]
4-element Vector{Int64}:
 1
 2
 3
 4

julia> p = permutedims(v)
1×4 Matrix{Int64}:
 1  2  3  4

julia> r = transpose(v)
1×4 transpose(::Vector{Int64}) with eltype Int64:
 1  2  3  4

julia> p == r
true

julia> typeof(r)
Transpose{Int64, Vector{Int64}}

julia> p[1] = 5; r[2] = 6; # mutating p or r also changes v

julia> v # shares memory with both p and r
4-element Vector{Int64}:
 5
 6
 3
 4
```

ただし、要素自体が数値行列であるベクトルでは、`permutedims` の結果は `transpose` の結果と異なります。

```jldoctest; setup = :(using LinearAlgebra)
julia> V = [[[1 2; 3 4]]; [[5 6; 7 8]]]
2-element Vector{Matrix{Int64}}:
 [1 2; 3 4]
 [5 6; 7 8]

julia> permutedims(V)
1×2 Matrix{Matrix{Int64}}:
 [1 2; 3 4]  [5 6; 7 8]

julia> transpose(V)
1×2 transpose(::Vector{Matrix{Int64}}) with eltype Transpose{Int64, Matrix{Int64}}:
 [1 3; 2 4]  [5 7; 6 8]
```
