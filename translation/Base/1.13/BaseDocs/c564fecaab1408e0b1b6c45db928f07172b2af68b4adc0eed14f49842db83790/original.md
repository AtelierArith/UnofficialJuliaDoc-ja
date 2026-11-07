```julia
typeassert(x, type)
```

Throw a [`TypeError`](@ref) unless `x isa type`. The syntax `x::type` calls this function.

# Examples

```jldoctest
julia> typeassert(2.5, Int)
ERROR: TypeError: in typeassert, expected Int64, got a value of type Float64
Stacktrace:
[...]
```
