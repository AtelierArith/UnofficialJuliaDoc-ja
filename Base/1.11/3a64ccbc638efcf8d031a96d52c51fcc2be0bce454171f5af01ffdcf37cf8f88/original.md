```
@something(x...)
```

Short-circuiting version of [`something`](@ref).

# Examples

```jldoctest
julia> f(x) = (println("f($x)"); nothing);

julia> a = 1;

julia> a = @something a f(2) f(3) error("Unable to find default for `a`")
1

julia> b = nothing;

julia> b = @something b f(2) f(3) error("Unable to find default for `b`")
f(2)
f(3)
ERROR: Unable to find default for `b`
[...]

julia> b = @something b f(2) f(3) Some(nothing)
f(2)
f(3)

julia> b === nothing
true
```

!!! compat "Julia 1.7"
    This macro is available as of Julia 1.7.

