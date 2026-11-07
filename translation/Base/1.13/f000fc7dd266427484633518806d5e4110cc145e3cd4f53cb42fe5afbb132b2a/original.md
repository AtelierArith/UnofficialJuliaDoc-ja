```julia
isconcretetype(T)
```

Determine whether type `T` is a concrete type, meaning it could have direct instances (values `x` such that `typeof(x) === T`). Note that this is not the negation of `isabstracttype(T)`. If `T` is not a type, then return `false`.

!!! note
    While concrete types are not [abstract](@ref isabstracttype) and vice versa, types can be neither concrete nor abstract (for example, `Vector` (a [`UnionAll`](@ref))).


!!! note
    `T` must be the exact type that would be returned from `typeof`.  It is possible for a type `U` to exist such that `T == U`, `isconcretetype(T)`, but `!isconcretetype(U)`.


See also: [`isbits`](@ref), [`isabstracttype`](@ref), [`issingletontype`](@ref).

# Examples

```jldoctest
julia> isconcretetype(Complex)
false

julia> isconcretetype(Complex{Float32})
true

julia> isconcretetype(Vector)
false

julia> isconcretetype(Vector{Complex})
true

julia> isconcretetype(Vector{Complex{Float32}})
true

julia> isconcretetype(Union{})
false

julia> isconcretetype(Union{Int,String})
false

julia> isconcretetype(Tuple{T} where T<:Int)
false
```
