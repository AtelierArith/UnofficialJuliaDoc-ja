```
関数
```

すべての関数の抽象型。

# 例

```jldoctest
julia> isa(+, Function)
true

julia> typeof(sin)
typeof(sin) (関数 sin の単一型、Function のサブタイプ)

julia> ans <: Function
true
```
