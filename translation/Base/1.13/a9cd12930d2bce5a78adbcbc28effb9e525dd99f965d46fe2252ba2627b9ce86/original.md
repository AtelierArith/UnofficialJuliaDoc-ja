```julia
empty(v::AbstractVector, [eltype])
```

Create an empty vector similar to `v`, optionally changing the `eltype`.

See also: [`empty!`](@ref), [`isempty`](@ref), [`isassigned`](@ref).

# Examples

```jldoctest
julia> empty([1.0, 2.0, 3.0])
Float64[]

julia> empty([1.0, 2.0, 3.0], String)
String[]
```
