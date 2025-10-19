```julia
floatmin(T = Float64)
```

浮動小数点型 `T` で表現可能な最小の正の正規数を返します。

# 例

```jldoctest
julia> floatmin(Float16)
Float16(6.104e-5)

julia> floatmin(Float32)
1.1754944f-38

julia> floatmin()
2.2250738585072014e-308
```
