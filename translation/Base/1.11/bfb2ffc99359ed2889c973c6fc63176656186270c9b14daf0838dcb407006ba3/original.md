```
f = Returns(value)
```

Create a callable `f` such that `f(args...; kw...) === value` holds.

# Examples

```jldoctest
julia> f = Returns(42);

julia> f(1)
42

julia> f("hello", x=32)
42

julia> f.value
42
```

!!! compat "Julia 1.7"
    `Returns` requires at least Julia 1.7.

