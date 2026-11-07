```julia
os(p::AbstractPlatform)
```

Get the operating system for the given `Platform` object as a `String`.

# Examples

```jldoctest
julia> os(Platform("armv7l", "Linux"))
"linux"

julia> os(Platform("aarch64", "macos"))
"macos"
```
