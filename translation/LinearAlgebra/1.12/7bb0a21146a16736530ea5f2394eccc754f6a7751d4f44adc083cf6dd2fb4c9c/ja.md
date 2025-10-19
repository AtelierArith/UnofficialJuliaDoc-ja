```julia
LinearAlgebra.checksquare(A)
```

行列が正方行列であることを確認し、共通の次元を返します。複数の引数がある場合は、ベクトルを返します。

# 例

```jldoctest
julia> A = fill(1, (4,4)); B = fill(1, (5,5));

julia> LinearAlgebra.checksquare(A, B)
2-element Vector{Int64}:
 4
 5
```
