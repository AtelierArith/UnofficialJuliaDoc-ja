```julia
typeassert(x, type)
```

`x isa type` でない場合は [`TypeError`](@ref) をスローします。構文 `x::type` はこの関数を呼び出します。

# 例

```jldoctest
julia> typeassert(2.5, Int)
ERROR: TypeError: in typeassert, expected Int64, got a value of type Float64
Stacktrace:
[...]
```
