```
*(s::Union{AbstractString, AbstractChar}, t::Union{AbstractString, AbstractChar}...) -> AbstractString
```

Concatenate strings and/or characters, producing a [`String`](@ref) or [`AnnotatedString`](@ref) (as appropriate). This is equivalent to calling the [`string`](@ref) or [`annotatedstring`](@ref) function on the arguments. Concatenation of built-in string types always produces a value of type `String` but other string types may choose to return a string of a different type as appropriate.

# Examples

```jldoctest
julia> "Hello " * "world"
"Hello world"

julia> 'j' * "ulia"
"julia"
```
