```julia
FieldError(type::DataType, field::Symbol)
```

オブジェクト `type` の無効な `field` にアクセスしようとしました。

!!! compat "Julia 1.12"
    Julia 1.12 より前のバージョンでは、無効なフィールドへのアクセス時に [`ErrorException`](@ref) がスローされていました。


[`getfield`](@ref) を参照してください。

# Examples

```jldoctest
julia> struct AB
          a::Float32
          b::Float64
       end

julia> ab = AB(1, 3)
AB(1.0f0, 3.0)

julia> ab.c # field `c` doesn't exist
ERROR: FieldError: type AB has no field `c`, available fields: `a`, `b`
Stacktrace:
[...]
```
