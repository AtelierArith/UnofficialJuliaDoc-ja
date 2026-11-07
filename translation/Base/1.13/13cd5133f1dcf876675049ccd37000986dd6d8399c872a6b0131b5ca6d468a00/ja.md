```julia
maximum(A::AbstractArray; dims)
```

指定した次元に沿って、配列の最大値を計算します。2つ以上の引数の最大値を求める関数[`max(a,b)`](@ref)も参照してください。この関数は、配列に対して`max.(a,b)`を使うことで要素ごとに適用できます。

関連項目: [`maximum!`](@ref)、[`extrema`](@ref)、[`findmax`](@ref)、[`argmax`](@ref)。

# Examples

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
