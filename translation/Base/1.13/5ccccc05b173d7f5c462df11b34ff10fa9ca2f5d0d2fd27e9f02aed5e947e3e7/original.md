```julia
isoverlong(c::AbstractChar)::Bool
```

Return `true` if `c` represents an overlong UTF-8 sequence. Defaults to `false` for non-`Char` types.

See also [`decode_overlong`](@ref) and [`show_invalid`](@ref).
