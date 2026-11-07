```julia
InexactError(name::Symbol, T, val)
```

関数 `name` のメソッド内で、`val` を型 `T` に正確に変換できません。

# Examples

```jldoctest
julia> convert(Float64, 1+2im)
ERROR: InexactError: Float64(1 + 2im)
Stacktrace:
[...]
```
