```julia
ismalformed(c::AbstractChar)::Bool
```

Return `true` if `c` represents malformed (non-Unicode) data according to the encoding used by `c`. Defaults to `false` for non-`Char` types.

See also [`show_invalid`](@ref).
