```
eachregion(s::AnnotatedString{S})
eachregion(s::SubString{AnnotatedString{S}})
```

Identify the contiguous substrings of `s` with a constant annotations, and return an iterator which provides each substring and the applicable annotations as a `Tuple{SubString{S}, Vector{@NamedTuple{label::Symbol, value::Any}}}`.

# Examples

```jldoctest
julia> collect(StyledStrings.eachregion(AnnotatedString(
           "hey there", [(1:3, :face, :bold), (5:9, :face, :italic)])))
3-element Vector{Tuple{SubString{String}, Vector{@NamedTuple{label::Symbol, value}}}}:
 ("hey", [@NamedTuple{label::Symbol, value}((:face, :bold))])
 (" ", [])
 ("there", [@NamedTuple{label::Symbol, value}((:face, :italic))])
```
