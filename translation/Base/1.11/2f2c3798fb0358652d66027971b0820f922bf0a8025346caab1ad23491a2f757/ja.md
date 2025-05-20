```
maximum(A::AbstractArray; dims)
```

与えられた次元にわたる配列の最大値を計算します。2つ以上の引数の最大値を取る[`max(a,b)`](@ref)関数も参照してください。これは`max.(a,b)`を介して配列に要素ごとに適用できます。

参照: [`maximum!`](@ref), [`extrema`](@ref), [`findmax`](@ref), [`argmax`](@ref).

# 例

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> maximum(A, dims=1)
1×2 Matrix{Int64}:
 3  4

julia> maximum(A, dims=2)
2×1 Matrix{Int64}:
 2
 4
```
