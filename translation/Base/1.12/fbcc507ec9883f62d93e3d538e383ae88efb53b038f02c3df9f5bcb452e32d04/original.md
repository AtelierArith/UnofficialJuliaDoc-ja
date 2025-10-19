```julia
print([io::IO], xs...)
```

Write to `io` (or to the default output stream [`stdout`](@ref) if `io` is not given) a canonical (un-decorated) text representation. The representation used by `print` includes minimal formatting and tries to avoid Julia-specific details.

`print` falls back to calling the 2-argument `show(io, x)` for each argument `x` in `xs`, so most types should just define `show`. Define `print` if your type has a separate "plain" representation.  For example, `show` displays strings with quotes, and `print` displays strings without quotes.

See also [`println`](@ref), [`string`](@ref), [`printstyled`](@ref).

# Examples

```jldoctest
julia> print("Hello World!")
Hello World!
julia> io = IOBuffer();

julia> print(io, "Hello", ' ', :World!)

julia> String(take!(io))
"Hello World!"
```
