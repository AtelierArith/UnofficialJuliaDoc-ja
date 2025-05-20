```
median(A::AbstractArray; dims)
```

与えられた次元に沿った配列の中央値を計算します。

# 例

```jldoctest
julia> using Statistics

julia> median([1 2; 3 4], dims=1)
1×2 Matrix{Float64}:
 2.0  3.0
```
