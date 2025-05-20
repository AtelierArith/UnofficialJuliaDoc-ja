```
diagm(kv::Pair{<:Integer,<:AbstractVector}...)
diagm(m::Integer, n::Integer, kv::Pair{<:Integer,<:AbstractVector}...)

`Pair`の対角線とベクトルから行列を構築します。ベクトル `kv.second` は `kv.first` 対角線に配置されます。デフォルトでは行列は正方形で、そのサイズは `kv` から推測されますが、非正方形のサイズ `m`×`n`（必要に応じてゼロでパディングされる）を最初の引数として `m,n` を渡すことで指定できます。繰り返しの対角線インデックス `kv.first` に対しては、対応するベクトル `kv.second` の値が加算されます。

`diagm` はフル行列を構築します。ストレージ効率の良いバージョンで高速な算術演算を希望する場合は、[`Diagonal`](@ref)、[`Bidiagonal`](@ref)、[`Tridiagonal`](@ref)、および [`SymTridiagonal`](@ref) を参照してください。

# 例

```

jldoctest julia> diagm(1 => [1,2,3]) 4×4 Matrix{Int64}:  0  1  0  0  0  0  2  0  0  0  0  3  0  0  0  0

julia> diagm(1 => [1,2,3], -1 => [4,5]) 4×4 Matrix{Int64}:  0  1  0  0  4  0  2  0  0  5  0  3  0  0  0  0

julia> diagm(1 => [1,2,3], 1 => [1,2,3]) 4×4 Matrix{Int64}:  0  2  0  0  0  0  4  0  0  0  0  6  0  0  0  0 ```
