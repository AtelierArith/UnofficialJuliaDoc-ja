```julia
get(val::ScopedValue{T})::Union{Nothing, Some{T}}
```

If the scoped value isn't set and doesn't have a default value, return `nothing`. Otherwise returns `Some{T}` with the current value.

See also: [`ScopedValues.with`](@ref), [`ScopedValues.@with`](@ref), [`ScopedValues.ScopedValue`](@ref).

# Examples

```jldoctest
julia> using Base.ScopedValues

julia> a = ScopedValue(42); b = ScopedValue{Int}();

julia> ScopedValues.get(a)
Some(42)

julia> isnothing(ScopedValues.get(b))
true
```
