```
AnnotatedChar{S <: AbstractChar} <: AbstractChar
```

A Char with annotations.

More specifically, this is a simple wrapper around any other [`AbstractChar`](@ref), which holds a list of arbitrary labelled annotations (`@NamedTuple{label::Symbol, value}`) with the wrapped character.

See also: [`AnnotatedString`](@ref), [`annotatedstring`](@ref), `annotations`, and `annotate!`.

# Constructors

```julia
AnnotatedChar(s::S) -> AnnotatedChar{S}
AnnotatedChar(s::S, annotations::Vector{@NamedTuple{label::Symbol, value}})
```

# Examples

```julia-repl
julia> AnnotatedChar('j', :label => 1)
'j': ASCII/Unicode U+006A (category Ll: Letter, lowercase)
```
