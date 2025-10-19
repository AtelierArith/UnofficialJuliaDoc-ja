```julia
promote_type(type1, type2, ...)
```

Promotion refers to converting values of mixed types to a single common type. `promote_type` represents the default promotion behavior in Julia when operators (usually mathematical) are given arguments of differing types. `promote_type` generally tries to return a type which can at least approximate most values of either input type without excessively widening.  Some loss is tolerated; for example, `promote_type(Int64, Float64)` returns [`Float64`](@ref) even though strictly, not all [`Int64`](@ref) values can be represented exactly as `Float64` values.

See also: [`promote`](@ref), [`promote_typejoin`](@ref), [`promote_rule`](@ref).

# Examples

```jldoctest
julia> promote_type(Int64, Float64)
Float64

julia> promote_type(Int32, Int64)
Int64

julia> promote_type(Float32, BigInt)
BigFloat

julia> promote_type(Int16, Float16)
Float16

julia> promote_type(Int64, Float16)
Float16

julia> promote_type(Int8, UInt16)
UInt16
```

!!! warning "Don't overload this directly"
    To overload promotion for your own types you should overload [`promote_rule`](@ref). `promote_type` calls `promote_rule` internally to determine the type. Overloading `promote_type` directly can cause ambiguity errors.

