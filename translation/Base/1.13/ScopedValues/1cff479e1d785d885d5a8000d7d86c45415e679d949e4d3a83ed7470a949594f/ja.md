```julia
get(val::ScopedValue{T})::Union{Nothing, Some{T}}
get(val::LazyScopedValue{T})::Union{Nothing, Some{T}}
```

スコープ内の値が設定されておらず、デフォルト値もない場合は、`nothing`を返します。それ以外の場合は、現在の値を含む`Some{T}`を返します。

関連項目: [`ScopedValues.with`](@ref)、[`ScopedValues.@with`](@ref)、[`ScopedValues.ScopedValue`](@ref)。

# Examples

```jldoctest
julia> using Base.ScopedValues

julia> a = ScopedValue(42); b = ScopedValue{Int}();

julia> ScopedValues.get(a)
Some(42)

julia> isnothing(ScopedValues.get(b))
true
```
