```
Union{}
```

`Union{}`, the empty [`Union`](@ref) of types, is the type that has no values. That is, it has the defining property `isa(x, Union{}) == false` for any `x`. `Base.Bottom` is defined as its alias and the type of `Union{}` is `Core.TypeofBottom`.

# Examples

```jldoctest
julia> isa(nothing, Union{})
false
```
