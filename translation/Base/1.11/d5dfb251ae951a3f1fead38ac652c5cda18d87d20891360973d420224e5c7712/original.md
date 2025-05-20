```
@coalesce(x...)
```

Short-circuiting version of [`coalesce`](@ref).

# Examples

```jldoctest
julia> f(x) = (println("f($x)"); missing);

julia> a = 1;

julia> a = @coalesce a f(2) f(3) error("`a` is still missing")
1

julia> b = missing;

julia> b = @coalesce b f(2) f(3) error("`b` is still missing")
f(2)
f(3)
ERROR: `b` is still missing
[...]
```

!!! compat "Julia 1.7"
    This macro is available as of Julia 1.7.

