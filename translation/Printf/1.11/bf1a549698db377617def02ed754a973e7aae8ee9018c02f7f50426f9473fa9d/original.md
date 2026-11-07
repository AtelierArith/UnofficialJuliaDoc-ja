```julia
@sprintf("%Fmt", args...)
```

Return [`@printf`](@ref) formatted output as string.

# Examples

```jldoctest
julia> @sprintf "this is a %s %15.1f" "test" 34.567
"this is a test            34.6"
```
