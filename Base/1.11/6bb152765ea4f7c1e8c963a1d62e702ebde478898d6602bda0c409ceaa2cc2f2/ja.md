```
unsafe_trunc(T, x)
```

型 `T` の絶対値が `x` の絶対値以下である最も近い整数値を返します。値が `T` で表現できない場合は、任意の値が返されます。詳細は [`trunc`](@ref) を参照してください。

# 例

```jldoctest
julia> unsafe_trunc(Int, -2.2)
-2

julia> unsafe_trunc(Int, NaN)
-9223372036854775808
```
