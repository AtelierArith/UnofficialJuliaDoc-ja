```julia
istextmime(m::MIME)
```

Determine whether a MIME type is text data. MIME types are assumed to be binary data except for a set of types known to be text data (possibly Unicode).

# Examples

```jldoctest
julia> istextmime(MIME("text/plain"))
true

julia> istextmime(MIME("image/png"))
false
```
