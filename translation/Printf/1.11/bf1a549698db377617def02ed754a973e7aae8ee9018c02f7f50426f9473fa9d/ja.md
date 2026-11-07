```julia
@sprintf("%Fmt", args...)
```

[`@printf`](@ref) 形式の出力を文字列として返してください。

# Examples

```jldoctest
julia> @sprintf "this is a %s %15.1f" "test" 34.567
"this is a test            34.6"
```
