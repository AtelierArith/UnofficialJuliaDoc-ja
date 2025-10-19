```julia
diagm(v::AbstractVector)
diagm(m::Integer, n::Integer, v::AbstractVector)
```

ベクトルの要素を対角要素とする行列を構築します。デフォルトでは、行列は正方形で、そのサイズは `length(v)` で指定されますが、最初の引数として `m,n` を渡すことで非正方形のサイズ `m`×`n` を指定できます。必要に応じて対角線はゼロでパディングされます。

# 例

```jldoctest
julia> diagm([1,2,3])
3×3 Matrix{Int64}:
 1  0  0
 0  2  0
 0  0  3

julia> diagm(4, 5, [1,2,3])
4×5 Matrix{Int64}:
 1  0  0  0  0
 0  2  0  0  0
 0  0  3  0  0
 0  0  0  0  0
```
