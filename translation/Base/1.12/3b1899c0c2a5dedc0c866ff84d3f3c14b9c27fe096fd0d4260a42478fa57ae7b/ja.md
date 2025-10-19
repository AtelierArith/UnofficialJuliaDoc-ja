```julia
minimum(A::AbstractArray; dims)
```

与えられた次元にわたる配列の最小値を計算します。二つ以上の引数の最小値を取るための[`min(a,b)`](@ref)関数も参照してください。これは`min.(a,b)`を介して配列に要素ごとに適用できます。

参照: [`minimum!`](@ref), [`extrema`](@ref), [`findmin`](@ref), [`argmin`](@ref).

# 例

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> minimum(A, dims=1)
1×2 Matrix{Int64}:
 1  2

julia> minimum(A, dims=2)
2×1 Matrix{Int64}:
 1
 3
```
