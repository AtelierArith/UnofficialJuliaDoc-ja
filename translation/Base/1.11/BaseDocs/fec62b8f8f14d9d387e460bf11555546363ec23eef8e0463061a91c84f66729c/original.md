```
where
```

The `where` keyword creates a [`UnionAll`](@ref) type, which may be thought of as an iterated union of other types, over all values of some variable. For example `Vector{T} where T<:Real` includes all [`Vector`](@ref)s where the element type is some kind of `Real` number.

The variable bound defaults to [`Any`](@ref) if it is omitted:

```julia
Vector{T} where T    # short for `where T<:Any`
```

Variables can also have lower bounds:

```julia
Vector{T} where T>:Int
Vector{T} where Int<:T<:Real
```

There is also a concise syntax for nested `where` expressions. For example, this:

```julia
Pair{T, S} where S<:Array{T} where T<:Number
```

can be shortened to:

```julia
Pair{T, S} where {T<:Number, S<:Array{T}}
```

This form is often found on method signatures.

Note that in this form, the variables are listed outermost-first. This matches the order in which variables are substituted when a type is "applied" to parameter values using the syntax `T{p1, p2, ...}`.
