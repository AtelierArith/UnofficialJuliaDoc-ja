```julia
unmark(s::IO)
```

Remove a mark from stream `s`. Return `true` if the stream was marked, `false` otherwise.

See also [`mark`](@ref), [`reset`](@ref), [`ismarked`](@ref).
