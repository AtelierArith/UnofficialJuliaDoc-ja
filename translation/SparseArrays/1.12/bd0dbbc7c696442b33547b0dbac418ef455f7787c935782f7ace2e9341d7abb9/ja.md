```julia
spdiagm(v::AbstractVector)
spdiagm(m::Integer, n::Integer, v::AbstractVector)
```

ベクトルの要素を対角要素とする疎行列を構築します。デフォルトでは（`m`と`n`が指定されていない場合）、行列は正方形で、そのサイズは`length(v)`によって決まりますが、最初の引数として`m`と`n`を渡すことで非正方形のサイズ`m`×`n`を指定できます。

!!! compat "Julia 1.6"
    これらの関数は少なくともJulia 1.6を必要とします。


# 例

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
