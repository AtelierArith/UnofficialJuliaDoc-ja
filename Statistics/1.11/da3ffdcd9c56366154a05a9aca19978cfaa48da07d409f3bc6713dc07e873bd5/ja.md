```
mean(f, A::AbstractArray; dims)
```

配列 `A` の各要素に関数 `f` を適用し、次元 `dims` にわたって平均を取ります。

!!! compat "Julia 1.3"
    このメソッドは少なくとも Julia 1.3 を必要とします。


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
