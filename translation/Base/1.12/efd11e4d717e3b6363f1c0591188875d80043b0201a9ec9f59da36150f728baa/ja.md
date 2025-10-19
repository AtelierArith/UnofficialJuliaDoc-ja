```julia
widemul(x, y)
```

`x` と `y` を掛け算し、結果をより大きな型で返します。

関連情報としては [`promote`](@ref)、[`Base.add_sum`](@ref) があります。

# 例

```jldoctest
julia> widemul(Float32(3.0), 4.0) isa BigFloat
true

julia> typemax(Int8) * typemax(Int8)
1

julia> widemul(typemax(Int8), typemax(Int8))  # == 127^2
16129
```
