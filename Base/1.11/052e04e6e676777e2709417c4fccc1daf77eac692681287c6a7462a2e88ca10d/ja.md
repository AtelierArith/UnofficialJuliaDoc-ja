```
@int128_str str
```

`str`を[`Int128`](@ref)として解析します。文字列が有効な整数でない場合は`ArgumentError`をスローします。

# 例

```jldoctest
julia> int128"123456789123"
123456789123

julia> int128"123456789123.4"
ERROR: LoadError: ArgumentError: invalid base 10 digit '.' in "123456789123.4"
[...]
```
