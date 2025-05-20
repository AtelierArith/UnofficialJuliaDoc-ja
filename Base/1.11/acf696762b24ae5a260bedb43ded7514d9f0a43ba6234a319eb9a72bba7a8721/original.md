```
mergewith(combine, d::AbstractDict, others::AbstractDict...)
mergewith(combine)
merge(combine, d::AbstractDict, others::AbstractDict...)
```

Construct a merged collection from the given collections. If necessary, the types of the resulting collection will be promoted to accommodate the types of the merged collections. Values with the same key will be combined using the combiner function.  The curried form `mergewith(combine)` returns the function `(args...) -> mergewith(combine, args...)`.

Method `merge(combine::Union{Function,Type}, args...)` as an alias of `mergewith(combine, args...)` is still available for backward compatibility.

!!! compat "Julia 1.5"
    `mergewith` requires Julia 1.5 or later.


# Examples

```jldoctest
julia> a = Dict("foo" => 0.0, "bar" => 42.0)
Dict{String, Float64} with 2 entries:
  "bar" => 42.0
  "foo" => 0.0

julia> b = Dict("baz" => 17, "bar" => 4711)
Dict{String, Int64} with 2 entries:
  "bar" => 4711
  "baz" => 17

julia> mergewith(+, a, b)
Dict{String, Float64} with 3 entries:
  "bar" => 4753.0
  "baz" => 17.0
  "foo" => 0.0

julia> ans == mergewith(+)(a, b)
true
```
