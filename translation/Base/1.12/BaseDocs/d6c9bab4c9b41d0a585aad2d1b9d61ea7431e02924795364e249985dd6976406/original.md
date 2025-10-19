```julia
::
```

The `::` operator either asserts that a value has the given type, or declares that a local variable or function return always has the given type.

Given `expression::T`, `expression` is first evaluated. If the result is of type `T`, the value is simply returned. Otherwise, a [`TypeError`](@ref) is thrown.

In local scope, the syntax `local x::T` or `x::T = expression` declares that local variable `x` always has type `T`. When a value is assigned to the variable, it will be converted to type `T` by calling [`convert`](@ref).

In a method declaration, the syntax `function f(x)::T` causes any value returned by the method to be converted to type `T`.

See the manual section on [Type Declarations](@ref).

# Examples

```jldoctest
julia> (1+2)::AbstractFloat
ERROR: TypeError: typeassert: expected AbstractFloat, got a value of type Int64

julia> (1+2)::Int
3

julia> let
           local x::Int
           x = 2.0
           x
       end
2
```
