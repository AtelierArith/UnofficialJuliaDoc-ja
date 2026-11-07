```julia
call_abi(p::AbstractPlatform)
```

Get the call ABI for the given `Platform` object as a `String`.  Returns `nothing` on platforms with no explicit `call_abi` choices (which is most platforms).

# Examples

```jldoctest
julia> call_abi(Platform("armv7l", "Linux"))
"eabihf"

julia> call_abi(Platform("x86_64", "macos"))
```
