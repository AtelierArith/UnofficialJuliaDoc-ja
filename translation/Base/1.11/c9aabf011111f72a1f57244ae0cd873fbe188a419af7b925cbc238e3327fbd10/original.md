```
eachrsplit(str::AbstractString, dlm; limit::Integer=0, keepempty::Bool=true)
eachrsplit(str::AbstractString; limit::Integer=0, keepempty::Bool=false)
```

Return an iterator over `SubString`s of `str`, produced when splitting on the delimiter(s) `dlm`, and yielded in reverse order (from right to left). `dlm` can be any of the formats allowed by [`findprev`](@ref)'s first argument (i.e. a string, a single character or a function), or a collection of characters.

If `dlm` is omitted, it defaults to [`isspace`](@ref), and `keepempty` default to `false`.

The optional keyword arguments are:

  * If `limit > 0`, the iterator will split at most `limit - 1` times before returning the rest of the string unsplit. `limit < 1` implies no cap to splits (default).
  * `keepempty`: whether empty fields should be returned when iterating Default is `false` without a `dlm` argument, `true` with a `dlm` argument.

Note that unlike [`split`](@ref), [`rsplit`](@ref) and [`eachsplit`](@ref), this function iterates the substrings right to left as they occur in the input.

See also [`eachsplit`](@ref), [`rsplit`](@ref).

!!! compat "Julia 1.11"
    This function requires Julia 1.11 or later.


# Examples

```jldoctest
julia> a = "Ma.r.ch";

julia> collect(eachrsplit(a, ".")) == ["ch", "r", "Ma"]
true

julia> collect(eachrsplit(a, "."; limit=2)) == ["ch", "Ma.r"]
true
```
