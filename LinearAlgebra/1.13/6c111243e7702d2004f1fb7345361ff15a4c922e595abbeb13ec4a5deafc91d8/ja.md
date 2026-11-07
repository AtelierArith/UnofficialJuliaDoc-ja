```julia
stride1(A) -> Int
```

次元 1 における隣接する配列要素間の距離を、要素サイズを単位として返します。

# Examples

```jldoctest
julia> A = [1,2,3,4]
4-element Vector{Int64}:
 1
 2
 3
 4

julia> LinearAlgebra.stride1(A)
1

julia> B = view(A, 2:2:4)
2-element view(::Vector{Int64}, 2:2:4) with eltype Int64:
 2
 4

julia> LinearAlgebra.stride1(B)
2
```
