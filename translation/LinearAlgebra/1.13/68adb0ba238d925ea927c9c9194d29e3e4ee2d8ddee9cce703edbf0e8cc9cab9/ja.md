```julia
isdiag(A) -> Bool
```

行列が対角行列であるかを判定します。`iszero(A[i,j])` が真であるのは、`i == j` の場合に限ります。`A` は正方行列である必要はありません。正方行列かどうかも確認したい場合は、`size(A, 1) == size(A, 2)` を確認してください。

# Examples

```jldoctest
julia> a = [1 2; 2 -1]
2×2 Matrix{Int64}:
 1   2
 2  -1

julia> isdiag(a)
false

julia> b = [im 0; 0 -im]
2×2 Matrix{Complex{Int64}}:
 0+1im  0+0im
 0+0im  0-1im

julia> isdiag(b)
true

julia> c = [1 0 0; 0 2 0]
2×3 Matrix{Int64}:
 1  0  0
 0  2  0

julia> isdiag(c)
true

julia> d = [1 0 0; 0 2 3]
2×3 Matrix{Int64}:
 1  0  0
 0  2  3

julia> isdiag(d)
false
```
