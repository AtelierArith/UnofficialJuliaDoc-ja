```
@NamedTuple{key1::Type1, key2::Type2, ...}
@NamedTuple begin key1::Type1; key2::Type2; ...; end
```

This macro gives a more convenient syntax for declaring `NamedTuple` types. It returns a `NamedTuple` type with the given keys and types, equivalent to `NamedTuple{(:key1, :key2, ...), Tuple{Type1,Type2,...}}`. If the `::Type` declaration is omitted, it is taken to be `Any`.   The `begin ... end` form allows the declarations to be split across multiple lines (similar to a `struct` declaration), but is otherwise equivalent. The `NamedTuple` macro is used when printing `NamedTuple` types to e.g. the REPL.

For example, the tuple `(a=3.1, b="hello")` has a type `NamedTuple{(:a, :b), Tuple{Float64, String}}`, which can also be declared via `@NamedTuple` as:

```jldoctest
julia> @NamedTuple{a::Float64, b::String}
@NamedTuple{a::Float64, b::String}

julia> @NamedTuple begin
           a::Float64
           b::String
       end
@NamedTuple{a::Float64, b::String}
```

!!! compat "Julia 1.5"
    This macro is available as of Julia 1.5.

