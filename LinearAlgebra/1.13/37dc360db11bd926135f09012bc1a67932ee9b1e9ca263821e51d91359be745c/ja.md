```julia
ldiv!(a::Number, B::AbstractArray)
```

配列 `B` の各要素をスカラー `a` で除算し、`B` をインプレースで上書きします。スカラーを右から除算するには、[`rdiv!`](@ref) を使用します。

# Examples

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
