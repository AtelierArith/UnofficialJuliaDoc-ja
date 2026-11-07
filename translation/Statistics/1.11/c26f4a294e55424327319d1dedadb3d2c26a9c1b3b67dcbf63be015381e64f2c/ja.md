```julia
mean(f, A::AbstractArray; dims)
```

配列 `A` の各要素に関数 `f` を適用し、次元 `dims` にわたる平均を求めます。

!!! compat "Julia 1.3"
    このメソッドを使用するには、Julia 1.3 以降が必要です。


```jldoctest
julia> using Statistics

julia> mean(√, [1, 2, 3])
1.3820881233139908

julia> mean([√1, √2, √3])
1.3820881233139908

julia> mean(√, [1 2 3; 4 5 6], dims=2)
2×1 Matrix{Float64}:
 1.3820881233139908
 2.2285192400943226
```
