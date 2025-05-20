```
ComposedFunction{Outer,Inner} <: Function
```

Represents the composition of two callable objects `outer::Outer` and `inner::Inner`. That is

```julia
ComposedFunction(outer, inner)(args...; kw...) === outer(inner(args...; kw...))
```

The preferred way to construct an instance of `ComposedFunction` is to use the composition operator [`∘`](@ref):

```jldoctest
julia> sin ∘ cos === ComposedFunction(sin, cos)
true

julia> typeof(sin∘cos)
ComposedFunction{typeof(sin), typeof(cos)}
```

The composed pieces are stored in the fields of `ComposedFunction` and can be retrieved as follows:

```jldoctest
julia> composition = sin ∘ cos
sin ∘ cos

julia> composition.outer === sin
true

julia> composition.inner === cos
true
```

!!! compat "Julia 1.6"
    ComposedFunction requires at least Julia 1.6. In earlier versions `∘` returns an anonymous function instead.


See also [`∘`](@ref).
