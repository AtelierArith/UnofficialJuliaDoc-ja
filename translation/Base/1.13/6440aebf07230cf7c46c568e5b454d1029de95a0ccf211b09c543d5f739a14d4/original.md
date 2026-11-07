```julia
Regex(pattern[, flags]) <: AbstractPattern
```

A type representing a regular expression. `Regex` objects can be used to match strings with [`match`](@ref).

`Regex` objects can be created using the [`@r_str`](@ref) string macro. The `Regex(pattern[, flags])` constructor is usually used if the `pattern` string needs to be interpolated. See the documentation of the string macro for details on flags.

!!! note
    To escape interpolated variables use `\Q` and `\E` (e.g. `Regex("\\Q$x\\E")`)

