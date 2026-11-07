```julia
middle(a::AbstractArray)
```

配列 `a` の中央の値を求めます。これは、配列の最小値と最大値を見つけ、その平均を計算することです。

```jldoctest
julia> using Statistics

julia> middle(1:10)
5.5

julia> a = [1,2,3.6,10.9]
4-element Vector{Float64}:
  1.0
  2.0
  3.6
 10.9

julia> middle(a)
5.95
```
