```julia
mean!(r, v)
```

`v`の平均を`r`の単一次元にわたって計算し、結果を`r`に書き込みます。ターゲットはソースとエイリアスしてはいけません。

# 例

```jldoctest
julia> using Statistics

julia> v = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> mean!([1., 1.], v)
2-element Vector{Float64}:
 1.5
 3.5

julia> mean!([1. 1.], v)
1×2 Matrix{Float64}:
 2.0  3.0
```
