```
typejoin(T, S, ...)
```

型 `T` と `S` の最も近い共通の祖先を返します。つまり、両方が継承する最も狭い型です。追加の varargs に対して再帰します。

# 例

```jldoctest
julia> typejoin(Int, Float64)
Real

julia> typejoin(Int, Float64, ComplexF32)
Number
```
