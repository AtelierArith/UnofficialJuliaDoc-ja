```
InexactError(name::Symbol, T, val)
```

`val`を関数`name`のメソッドの型`T`に正確に変換できません。

# 例

```jldoctest
julia> convert(Float64, 1+2im)
ERROR: InexactError: Float64(1 + 2im)
Stacktrace:
[...]
```
