```julia
spdiagm(v::AbstractVector)
spdiagm(m::Integer, n::Integer, v::AbstractVector)
```

ベクトルの要素を対角成分とする疎行列を構築します。デフォルトでは（`m` と `n` を指定しない場合）、行列は正方行列となり、そのサイズは `length(v)` で決まります。ただし、最初の引数として `m` と `n` を渡すことで、`m`×`n` の非正方行列を指定できます。

!!! compat "Julia 1.6"
    これらの関数を使用するには、Julia 1.6 以降が必要です。


# Examples

```jldoctest
julia> spdiagm([1,2,3])
3×3 SparseMatrixCSC{Int64, Int64} with 3 stored entries:
 1  ⋅  ⋅
 ⋅  2  ⋅
 ⋅  ⋅  3

julia> spdiagm(sparse([1,0,3]))
3×3 SparseMatrixCSC{Int64, Int64} with 2 stored entries:
 1  ⋅  ⋅
 ⋅  ⋅  ⋅
 ⋅  ⋅  3
```
