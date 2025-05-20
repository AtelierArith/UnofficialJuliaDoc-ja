```
occursin(haystack)
```

Create a function that checks whether its argument occurs in `haystack`, i.e. a function equivalent to `needle -> occursin(needle, haystack)`.

The returned function is of type `Base.Fix2{typeof(occursin)}`.

!!! compat "Julia 1.6"
    This method requires Julia 1.6 or later.


# Examples

```jldoctest
julia> search_f = occursin("JuliaLang is a programming language");

julia> search_f("JuliaLang")
true

julia> search_f("Python")
false
```
