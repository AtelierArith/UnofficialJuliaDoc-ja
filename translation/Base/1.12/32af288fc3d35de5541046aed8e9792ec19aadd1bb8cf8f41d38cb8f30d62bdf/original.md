```julia
isconcretetype(T)
```

Determine whether type `T` is a concrete type, meaning it could have direct instances (values `x` such that `typeof(x) === T`). Note that this is not the negation of `isabstracttype(T)`. If `T` is not a type, then return `false`.

See also: [`isbits`](@ref), [`isabstracttype`](@ref), [`issingletontype`](@ref).

# Examples

```jldoctest
julia> isconcretetype(Complex)
false

julia> isconcretetype(Complex{Float32})
true

julia> isconcretetype(Vector{Complex})
true

julia> isconcretetype(Vector{Complex{Float32}})
true

julia> isconcretetype(Union{})
false

julia> isconcretetype(Union{Int,String})
false
```
