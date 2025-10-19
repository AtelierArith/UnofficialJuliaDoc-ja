```julia
nameof(m::Module) -> Symbol
```

Get the name of a `Module` as a [`Symbol`](@ref).

# Examples

```jldoctest
julia> nameof(Base.Broadcast)
:Broadcast
```
