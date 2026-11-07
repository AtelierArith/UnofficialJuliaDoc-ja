```julia
Union{}
```

`Union{}`, the empty [`Union`](@ref) of types, is the *bottom* type of the type system. That is, for each `T::Type`, `Union{} <: T`. Also see the subtyping operator's documentation: [`<:`](@ref).

As such, `Union{}` is also an *empty*/*uninhabited* type, meaning that it has no values. That is, for each `x`, `isa(x, Union{}) == false`.

`Base.Bottom` is defined as its alias and the type of `Union{}` is `Core.TypeofBottom`.

# Examples

```jldoctest
julia> isa(nothing, Union{})
false

julia> Union{} <: Int
true

julia> typeof(Union{}) === Core.TypeofBottom
true

julia> isa(Union{}, Union)
false
```
