```julia
typeassert(x, type)
```

[`TypeError`](@ref) をスローします。ただし、`x isa type` の場合を除きます。構文 `x::type` はこの関数を呼び出します。

# Examples

```jldoctest
julia> typeassert(2.5, Int)
ERROR: TypeError: in typeassert, expected Int64, got a value of type Float64
Stacktrace:
[...]
```
