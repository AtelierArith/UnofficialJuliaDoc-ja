```julia
@md_str -> MD
```

Parse the given string as Markdown text and return a corresponding [`MD`](@ref) object.

See also [`Markdown.parse`](@ref Markdown.parse(::AbstractString)).

# Examples

```jldoctest
julia> s = md"# Hello, world!"
  Hello, world!
  ≡≡≡≡≡≡≡≡≡≡≡≡≡

julia> typeof(s)
Markdown.MD

```
