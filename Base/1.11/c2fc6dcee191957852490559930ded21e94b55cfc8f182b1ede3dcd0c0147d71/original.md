```
LazyString <: AbstractString
```

A lazy representation of string interpolation. This is useful when a string needs to be constructed in a context where performing the actual interpolation and string construction is unnecessary or undesirable (e.g. in error paths of functions).

This type is designed to be cheap to construct at runtime, trying to offload as much work as possible to either the macro or later printing operations.

# Examples

```jldoctest
julia> n = 5; str = LazyString("n is ", n)
"n is 5"
```

See also [`@lazy_str`](@ref).

!!! compat "Julia 1.8"
    `LazyString` requires Julia 1.8 or later.


# Extended help

## Safety properties for concurrent programs

A lazy string itself does not introduce any concurrency problems even if it is printed in multiple Julia tasks.  However, if `print` methods on a captured value can have a concurrency issue when invoked without synchronizations, printing the lazy string may cause an issue.  Furthermore, the `print` methods on the captured values may be invoked multiple times, though only exactly one result will be returned.

!!! compat "Julia 1.9"
    `LazyString` is safe in the above sense in Julia 1.9 and later.

