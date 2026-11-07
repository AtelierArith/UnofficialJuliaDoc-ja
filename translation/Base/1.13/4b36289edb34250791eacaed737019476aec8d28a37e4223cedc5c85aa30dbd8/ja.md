```julia
widemul(x, y)
```

`x` と `y` を乗算し、より大きな型で結果を返します。

関連項目: [`promote`](@ref)、[`Base.add_sum`](@ref)。

# Examples

```jldoctest
julia> widemul(Float32(3.0), 4.0) isa BigFloat
true

julia> typemax(Int8) * typemax(Int8)
1

julia> widemul(typemax(Int8), typemax(Int8))  # == 127^2
16129
```
