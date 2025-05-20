```
float(x)
```

数値または配列を浮動小数点データ型に変換します。

参照: [`complex`](@ref), [`oftype`](@ref), [`convert`](@ref).

# 例

```jldoctest
julia> float(1:1000)
1.0:1.0:1000.0

julia> float(typemax(Int32))
2.147483647e9
```
