```julia
isabstracttype(T)
```

型 `T` が抽象型として宣言されたかどうかを判断します（つまり、`abstract type` 構文を使用して）。これは `isconcretetype(T)` の否定ではないことに注意してください。もし `T` が型でない場合は、`false` を返します。

# 例

```jldoctest
julia> isabstracttype(AbstractArray)
true

julia> isabstracttype(Vector)
false
```
