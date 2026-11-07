```julia
arch(p::AbstractPlatform)
```

Get the architecture for the given `Platform` object as a `String`.

# Examples

```jldoctest
julia> arch(Platform("aarch64", "Linux"))
"aarch64"

julia> arch(Platform("amd64", "freebsd"))
"x86_64"
```
