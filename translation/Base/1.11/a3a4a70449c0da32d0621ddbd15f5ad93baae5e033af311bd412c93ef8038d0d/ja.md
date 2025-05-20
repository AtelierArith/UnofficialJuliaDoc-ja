```
angle(z)
```

複素数 `z` の位相角をラジアンで計算します。

`-pi ≤ angle(z) ≤ pi` の数を返し、したがって負の実軸に沿って不連続です。

関連項目: [`atan`](@ref), [`cis`](@ref), [`rad2deg`](@ref).

# 例

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
