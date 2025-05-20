```
spdiagm(kv::Pair{<:Integer,<:AbstractVector}...)
spdiagm(m::Integer, n::Integer, kv::Pair{<:Integer,<:AbstractVector}...)
```

`Pair`のベクトルと対角線からスパース対角行列を構築します。各ベクトル`kv.second`は`kv.first`対角線に配置されます。デフォルトでは、行列は正方形であり、そのサイズは`kv`から推測されますが、必要に応じてゼロでパディングされた非正方形のサイズ`m`×`n`を最初の引数として渡すことで指定できます。

# 例

```jldoctest
julia> spdiagm(-1 => [1,2,3,4], 1 => [4,3,2,1])
5×5 SparseMatrixCSC{Int64, Int64} with 8 stored entries:
 ⋅  4  ⋅  ⋅  ⋅
 1  ⋅  3  ⋅  ⋅
 ⋅  2  ⋅  2  ⋅
 ⋅  ⋅  3  ⋅  1
 ⋅  ⋅  ⋅  4  ⋅
```
