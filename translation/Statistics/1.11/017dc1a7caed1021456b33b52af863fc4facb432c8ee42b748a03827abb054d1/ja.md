```julia
median(A::AbstractArray; dims)
```

指定した次元に沿って配列の中央値を計算します。

# Examples

```jldoctest
julia> using Statistics

julia> median([1 2; 3 4], dims=1)
1×2 Matrix{Float64}:
 2.0  3.0
```
