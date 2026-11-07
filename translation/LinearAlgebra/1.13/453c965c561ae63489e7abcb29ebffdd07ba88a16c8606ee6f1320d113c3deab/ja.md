```julia
rdiv!(A::AbstractArray, b::Number)
```

配列 `A` の各要素をスカラー `b` で除算し、`A` をインプレースで上書きします。スカラーを左から除算するには [`ldiv!`](@ref) を使用します。

# Examples

```jldoctest
julia> A = [1.0 2.0; 3.0 4.0]
2×2 Matrix{Float64}:
 1.0  2.0
 3.0  4.0

julia> rdiv!(A, 2.0)
2×2 Matrix{Float64}:
 0.5  1.0
 1.5  2.0
```
