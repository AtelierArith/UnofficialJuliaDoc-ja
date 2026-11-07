```julia
eachregion(s::AnnotatedString{S})
eachregion(s::SubString{AnnotatedString{S}})
```

`s`のうち、注釈が一定である連続部分文字列を特定し、各部分文字列と該当する注釈を`Tuple{SubString{S}, Vector{@NamedTuple{label::Symbol, value}}}`として返すイテレーターを返します。

# Examples

```jldoctest; setup=:(using Base: AnnotatedString, eachregion)
julia> collect(eachregion(AnnotatedString(
           "hey there", [(1:3, :face, :bold),
                         (5:9, :face, :italic)])))
3-element Vector{Tuple{SubString{String}, Vector{@NamedTuple{label::Symbol, value}}}}:
 ("hey", [@NamedTuple{label::Symbol, value}((:face, :bold))])
 (" ", [])
 ("there", [@NamedTuple{label::Symbol, value}((:face, :italic))])
```
