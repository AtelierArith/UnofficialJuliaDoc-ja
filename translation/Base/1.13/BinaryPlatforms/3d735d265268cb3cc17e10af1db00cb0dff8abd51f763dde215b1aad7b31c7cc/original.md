```julia
libc(p::AbstractPlatform)
```

Get the libc for the given `Platform` object as a `String`.  Returns `nothing` on platforms with no explicit `libc` choices (which is most platforms).

# Examples

```jldoctest
julia> libc(Platform("armv7l", "Linux"))
"glibc"

julia> libc(Platform("aarch64", "linux"; libc="musl"))
"musl"

julia> libc(Platform("i686", "Windows"))
```
