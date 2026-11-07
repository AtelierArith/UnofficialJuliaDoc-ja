```julia
spdiagm(kv::Pair{<:Integer,<:AbstractVector}...)
spdiagm(m::Integer, n::Integer, kv::Pair{<:Integer,<:AbstractVector}...)
```

ベクトルと対角線の`Pair`から疎な対角行列を構築します。各ベクトル`kv.second`は、`kv.first`対角線上に配置されます。既定では行列は正方行列で、そのサイズは`kv`から推定されます。ただし、最初の引数として`m,n`を渡すと、必要に応じてゼロで埋められた、`m`×`n`の非正方行列を指定できます。

# Examples

```jldoctest
julia> spdiagm(-1 => [1,2,3,4], 1 => [4,3,2,1])
5×5 SparseMatrixCSC{Int64, Int64} with 8 stored entries:
 ⋅  4  ⋅  ⋅  ⋅
 1  ⋅  3  ⋅  ⋅
 ⋅  2  ⋅  2  ⋅
 ⋅  ⋅  3  ⋅  1
 ⋅  ⋅  ⋅  4  ⋅
```
