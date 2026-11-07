```julia
typeassert(x, type)
```

[`TypeError`](@ref)をスローします。ただし、`x isa type`の場合を除きます。この関数は、`x::type`という構文で呼び出します。

# Examples

```jldoctest
julia> typeassert(2.5, Int)
ERROR: TypeError: in typeassert, expected Int64, got a value of type Float64
Stacktrace:
[...]
```
