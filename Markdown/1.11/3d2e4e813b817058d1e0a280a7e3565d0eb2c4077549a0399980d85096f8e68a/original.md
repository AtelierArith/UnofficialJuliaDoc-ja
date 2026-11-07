```julia
@doc_str -> MD
```

Parse the given string as Markdown text, add line and module information and return a corresponding [`MD`](@ref) object.

`@doc_str` can be used in conjunction with the [`Base.Docs`](@ref) module. Please also refer to the manual section on [documentation](@ref man-documentation) for more information.

# Examples

```julia
julia> s = doc"f(x) = 2*x"
  f(x) = 2*x

julia> typeof(s)
Markdown.MD

```
