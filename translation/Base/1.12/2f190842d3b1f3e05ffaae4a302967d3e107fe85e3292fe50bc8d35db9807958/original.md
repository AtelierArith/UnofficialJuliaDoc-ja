```julia
string(xs...)
```

Create a string from any values using the [`print`](@ref) function.

`string` should usually not be defined directly. Instead, define a method `print(io::IO, x::MyType)`. If `string(x)` for a certain type needs to be highly efficient, then it may make sense to add a method to `string` and define `print(io::IO, x::MyType) = print(io, string(x))` to ensure the functions are consistent.

See also: [`String`](@ref), [`repr`](@ref), [`sprint`](@ref), [`show`](@ref @show).

# Examples

```jldoctest
julia> string("a", 1, true)
"a1true"
```
