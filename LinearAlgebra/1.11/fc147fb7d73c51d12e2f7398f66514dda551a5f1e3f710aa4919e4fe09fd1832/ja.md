```
ldiv!(a::Number, B::AbstractArray)
```

スカラー `a` で配列 `B` の各エントリを割り算し、`B` をその場で上書きします。スカラーを右から割るには [`rdiv!`](@ref) を使用してください。

# 例

```jldoctest
julia> B = [1.0 2.0; 3.0 4.0]
2×2 Matrix{Float64}:
 1.0  2.0
 3.0  4.0

julia> ldiv!(2.0, B)
2×2 Matrix{Float64}:
 0.5  1.0
 1.5  2.0
```
