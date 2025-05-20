```
startswith(s::AbstractString, prefix::Regex)
```

Return `true` if `s` starts with the regex pattern, `prefix`.

!!! note
    `startswith` does not compile the anchoring into the regular expression, but instead passes the anchoring as `match_option` to PCRE. If compile time is amortized, `occursin(r"^...", s)` is faster than `startswith(s, r"...")`.


See also [`occursin`](@ref) and [`endswith`](@ref).

!!! compat "Julia 1.2"
    This method requires at least Julia 1.2.


# Examples

```jldoctest
julia> startswith("JuliaLang", r"Julia|Romeo")
true
```
