```julia
Integer <: Real
```

すべての整数（例：[`Signed`](@ref)、[`Unsigned`](@ref)、[`Bool`](@ref)）の抽象スーパータイプです。

関連項目：[`isinteger`](@ref)、[`trunc`](@ref)、[`div`](@ref)。

# Examples

```julia
julia> 42 isa Integer
true

julia> 1.0 isa Integer
false

julia> isinteger(1.0)
true
```
