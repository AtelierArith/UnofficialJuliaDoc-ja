```julia
randn!([rng=default_rng()], A::AbstractArray) -> A
```

配列 `A` を平均 0、標準偏差 1 の正規分布に従う乱数で埋めます。[`rand`](@ref) 関数も参照してください。

# 例

```jldoctest
julia> randn!(Xoshiro(123), zeros(5))
5-element Vector{Float64}:
 -0.6457306721039767
 -1.4632513788889214
 -1.6236037455860806
 -0.21766510678354617
  0.4922456865251828
```
