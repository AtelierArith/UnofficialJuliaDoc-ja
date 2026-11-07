```julia
diagm(kv::Pair{<:Integer,<:AbstractVector}...)
diagm(m::Integer, n::Integer, kv::Pair{<:Integer,<:AbstractVector}...)
```

対角線とベクトルの`Pair`から行列を構築します。ベクトル`kv.second`は、`kv.first`対角線上に配置されます。デフォルトでは行列は正方行列で、そのサイズは`kv`から推定されます。ただし、最初の引数として`m,n`を渡すと、必要に応じてゼロで埋められる、`m`×`n`の非正方行列を指定できます。対角線のインデックス`kv.first`が重複する場合、対応するベクトル`kv.second`の値は加算されます。

`diagm`は通常の行列を構築します。メモリ効率が高く、演算も高速な形式が必要な場合は、[`Diagonal`](@ref)、[`Bidiagonal`](@ref) [`Tridiagonal`](@ref)、[`SymTridiagonal`](@ref)を参照してください。

# Examples

```jldoctest
julia> diagm(1 => [1,2,3])
4×4 Matrix{Int64}:
 0  1  0  0
 0  0  2  0
 0  0  0  3
 0  0  0  0

julia> diagm(1 => [1,2,3], -1 => [4,5])
4×4 Matrix{Int64}:
 0  1  0  0
 4  0  2  0
 0  5  0  3
 0  0  0  0

julia> diagm(1 => [1,2,3], 1 => [1,2,3])
4×4 Matrix{Int64}:
 0  2  0  0
 0  0  4  0
 0  0  0  6
 0  0  0  0
```
