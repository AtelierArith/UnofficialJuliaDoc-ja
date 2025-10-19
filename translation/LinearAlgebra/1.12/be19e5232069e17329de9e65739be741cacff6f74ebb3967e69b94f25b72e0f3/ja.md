```julia
rdiv!(A::AbstractArray, b::Number)
```

配列 `A` の各エントリをスカラー `b` で割り、`A` をその場で上書きします。スカラーを左から割るには [`ldiv!`](@ref) を使用してください。

# 例

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
