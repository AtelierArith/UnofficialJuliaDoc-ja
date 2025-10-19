```julia
<:(T1, T2)::Bool
```

Subtyping relation, defined between two types. In Julia, a type `S` is said to be a *subtype* of a type `T` if and only if we have `S <: T`.

For any type `L` and any type `R`, `L <: R` implies that any value `v` of type `L` is also of type `R`. I.e., `(L <: R) && (v isa L)` implies `v isa R`.

The subtyping relation is a *partial order*. I.e., `<:` is:

  * *reflexive*: for any type `T`, `T <: T` holds
  * *antisymmetric*: for any type `A` and any type `B`, `(A <: B) && (B <: A)` implies `A == B`
  * *transitive*: for any type `A`, any type `B` and any type `C`; `(A <: B) && (B <: C)` implies `A <: C`

See also info on [Types](@ref man-types), [`Union{}`](@ref), [`Any`](@ref), [`isa`](@ref).

# Examples

```jldoctest
julia> Float64 <: AbstractFloat
true

julia> Vector{Int} <: AbstractArray
true

julia> Matrix{Float64} <: Matrix{AbstractFloat}  # `Matrix` is invariant
false

julia> Tuple{Float64} <: Tuple{AbstractFloat}    # `Tuple` is covariant
true

julia> Union{} <: Int  # The bottom type, `Union{}`, subtypes each type.
true

julia> Union{} <: Float32 <: AbstractFloat <: Real <: Number <: Any  # Operator chaining
true
```

The `<:` keyword also has several syntactic uses which represent the same subtyping relation, but which do not execute the operator or return a Bool:

  * To specify the lower bound and the upper bound on a parameter of a [`UnionAll`](@ref) type in a [`where`](@ref) statement.
  * To specify the lower bound and the upper bound on a (static) parameter of a method, see [Parametric Methods](@ref).
  * To define a subtyping relation while declaring a new type, see [`struct`](@ref) and [`abstract type`](@ref).
