```julia
nameof(m::Module)::Symbol
```

`Module` の名前を [`Symbol`](@ref) として取得します。

# Examples

```jldoctest
julia> nameof(Base.Broadcast)
:Broadcast
```
