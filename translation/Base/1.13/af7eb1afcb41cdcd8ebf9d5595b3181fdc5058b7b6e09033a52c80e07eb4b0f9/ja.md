```julia
minimum(A::AbstractArray; dims)
```

指定した次元に沿って、配列の最小値を計算します。2つ以上の引数の最小値を求める[`min(a,b)`](@ref)関数も参照してください。この関数は、`min.(a,b)`を使って配列に要素ごとに適用できます。

関連項目: [`minimum!`](@ref)、[`extrema`](@ref)、[`findmin`](@ref)、[`argmin`](@ref)。

# Examples

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
