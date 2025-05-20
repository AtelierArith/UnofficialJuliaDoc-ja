```
shuffle!([rng=default_rng(),] v::AbstractArray)
```

[`shuffle`](@ref) のインプレースバージョン：`v` をインプレースでランダムに順序を入れ替え、オプションで乱数生成器 `rng` を指定します。

# 例

```jldoctest
julia> shuffle!(Xoshiro(123), Vector(1:10))
10-element Vector{Int64}:
  5
  4
  2
  3
  6
 10
  8
  1
  9
  7
```
