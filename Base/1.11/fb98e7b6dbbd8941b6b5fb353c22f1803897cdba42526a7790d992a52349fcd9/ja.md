```
@uint128_str str
```

`str`を[`UInt128`](@ref)として解析します。文字列が有効な整数でない場合は`ArgumentError`をスローします。

# 例

```
julia> uint128"123456789123"
0x00000000000000000000001cbe991a83

julia> uint128"-123456789123"
ERROR: LoadError: ArgumentError: invalid base 10 digit '-' in "-123456789123"
[...]
```
