```
endswith(s::AbstractString, suffix::Regex)
```

Return `true` if `s` ends with the regex pattern, `suffix`.

!!! note
    `endswith` does not compile the anchoring into the regular expression, but instead passes the anchoring as `match_option` to PCRE. If compile time is amortized, `occursin(r"...$", s)` is faster than `endswith(s, r"...")`.


See also [`occursin`](@ref) and [`startswith`](@ref).

!!! compat "Julia 1.2"
    This method requires at least Julia 1.2.


# Examples

```jldoctest
julia> endswith("JuliaLang", r"Lang|Roberts")
true
```
