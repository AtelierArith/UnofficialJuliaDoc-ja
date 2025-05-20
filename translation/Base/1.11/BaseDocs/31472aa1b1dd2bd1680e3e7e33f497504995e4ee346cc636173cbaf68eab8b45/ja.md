```
x || y
```

ショートサーキットブールOR。

参照: [`|`](@ref), [`xor`](@ref), [`&&`](@ref)。

# 例

```jldoctest
julia> pi < 3 || ℯ < 3
true

julia> false || true || println("neither is true!")
true
```
