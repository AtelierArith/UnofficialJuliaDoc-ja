```julia
mean(A::AbstractArray; dims)
```

指定された次元に沿って配列の平均を計算します。

!!! compat "Julia 1.1"
    空の配列に対する`mean`の使用には、Julia 1.1以降が必要です。


# Examples

```jldoctest
julia> using Statistics

julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> mean(A, dims=1)
1×2 Matrix{Float64}:
 2.0  3.0

julia> mean(A, dims=2)
2×1 Matrix{Float64}:
 1.5
 3.5
```
