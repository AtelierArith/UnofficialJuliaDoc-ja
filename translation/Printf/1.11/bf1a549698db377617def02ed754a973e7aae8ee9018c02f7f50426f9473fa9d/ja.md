```julia
@sprintf("%Fmt", args...)
```

[`@printf`](@ref) を文字列としてフォーマットした出力を返します。

# Examples

```jldoctest
julia> @sprintf "this is a %s %15.1f" "test" 34.567
"this is a test            34.6"
```
