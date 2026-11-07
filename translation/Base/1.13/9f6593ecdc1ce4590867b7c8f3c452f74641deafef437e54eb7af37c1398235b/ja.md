```julia
angle(z)
```

複素数 `z` の偏角をラジアンで計算します。

数値 `-pi ≤ angle(z) ≤ pi` を返すため、負の実軸上で不連続です。

関連項目: [`atan`](@ref)、[`cis`](@ref)、[`rad2deg`](@ref)。

# Examples

```jldoctest
julia> rad2deg(angle(1 + im))
45.0

julia> rad2deg(angle(1 - im))
-45.0

julia> rad2deg(angle(-1 + 1e-20im))
180.0

julia> rad2deg(angle(-1 - 1e-20im))
-180.0
```
