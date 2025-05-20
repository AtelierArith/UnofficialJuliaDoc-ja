```
permutedims(v::AbstractVector)
```

ベクトル `v` を `1 × length(v)` の行行列に変形します。操作が再帰的でないため、[`transpose`](@ref) とは異なり、非数値の値の配列に特に便利です（再帰的な `transpose` はエラーを引き起こす可能性があります）。

# 例

`transpose` とは異なり、`permutedims` は文字列などの任意の非数値要素のベクトルに使用できます：

```jldoctest
julia> permutedims(["a", "b", "c"])
1×3 Matrix{String}:
 "a"  "b"  "c"
```

数値のベクトルの場合、`permutedims(v)` は `transpose(v)` とほぼ同様に機能しますが、戻り値の型が異なります（`LinearAlgebra.Transpose` ビューではなく、[`reshape`](@ref) を使用しますが、どちらも元の配列 `v` とメモリを共有します）：

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

julia> p[1] = 5; r[2] = 6; # p または r を変更すると v も変わります

julia> v # p と r の両方とメモリを共有
4-element Vector{Int64}:
 5
 6
 3
 4
```

しかし、`permutedims` は、要素が数値行列であるベクトルに対しては `transpose` とは異なる結果を生成します：

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
