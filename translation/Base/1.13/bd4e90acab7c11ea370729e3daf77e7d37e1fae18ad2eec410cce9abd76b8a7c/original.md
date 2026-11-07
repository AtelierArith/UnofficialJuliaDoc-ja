```julia
show_invalid(io::IO, c::AbstractChar)
```

Called by `show(io, c)` when [`isoverlong(c)`](@ref) or [`ismalformed(c)`](@ref) return `true`.   Subclasses of `AbstractChar` should define `Base.show_invalid` methods if they support storing invalid character data.
