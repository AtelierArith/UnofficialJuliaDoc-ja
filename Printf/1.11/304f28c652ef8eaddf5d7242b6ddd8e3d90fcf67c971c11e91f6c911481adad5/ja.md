```
@sprintf("%Fmt", args...)
```

文字列として[`@printf`](@ref)形式の出力を返します。

# 例

```jldoctest
julia> @sprintf "this is a %s %15.1f" "test" 34.567
"this is a test            34.6"
```
