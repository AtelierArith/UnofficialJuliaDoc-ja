```julia
isassigned(val::ScopedValue)
```

`ScopedValue`に値が割り当てられているかどうかを確認します。

関連項目: [`ScopedValues.with`](@ref)、[`ScopedValues.@with`](@ref)、[`ScopedValues.get`](@ref)。

# Examples

```jldoctest
julia> using Base.ScopedValues

julia> a = ScopedValue(1); b = ScopedValue{Int}();

julia> isassigned(a)
true

julia> isassigned(b)
false
```
