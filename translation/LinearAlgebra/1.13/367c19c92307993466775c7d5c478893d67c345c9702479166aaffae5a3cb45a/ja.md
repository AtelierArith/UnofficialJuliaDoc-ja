```julia
diagm(v::AbstractVector)
diagm(m::Integer, n::Integer, v::AbstractVector)
```

ベクトルの要素を対角成分とする行列を構築します。デフォルトでは正方行列となり、そのサイズは`length(v)`で指定されます。最初の引数として`m,n`を渡すと、`m`×`n`の非正方行列を指定できます。必要に応じて、対角成分はゼロで埋められます。

# Examples

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
