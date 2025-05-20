```
valtype(type)
```

辞書型の値の型を取得します。[`eltype`](@ref)と似た動作をします。

# 例

```jldoctest
julia> valtype(Dict(Int32(1) => "foo"))
String
```
