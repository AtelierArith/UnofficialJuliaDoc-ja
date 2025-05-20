```
middle(a::AbstractArray)
```

配列 `a` の中央を計算します。これは、配列の極値を見つけてから、それらの平均を計算することを含みます。

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
