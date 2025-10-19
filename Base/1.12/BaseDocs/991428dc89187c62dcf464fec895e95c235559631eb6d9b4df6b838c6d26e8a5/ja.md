```julia
FieldError(type::DataType, field::Symbol)
```

操作が `type` のオブジェクトに対して無効な `field` にアクセスしようとしました。

!!! compat "Julia 1.12"
    Julia 1.12 より前は、無効なフィールドアクセスは [`ErrorException`](@ref) をスローしました。


[`getfield`](@ref) を参照してください。

# 例

```jldoctest
julia> struct AB
          a::Float32
          b::Float64
       end

julia> ab = AB(1, 3)
AB(1.0f0, 3.0)

julia> ab.c # フィールド `c` は存在しません
ERROR: FieldError: type AB has no field `c`, available fields: `a`, `b`
Stacktrace:
[...]
```
