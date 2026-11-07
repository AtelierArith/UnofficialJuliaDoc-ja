```julia
wordsize(p::AbstractPlatform)
```

Get the word size for the given `Platform` object.

# Examples

```jldoctest
julia> wordsize(Platform("armv7l", "linux"))
32

julia> wordsize(Platform("x86_64", "macos"))
64
```
