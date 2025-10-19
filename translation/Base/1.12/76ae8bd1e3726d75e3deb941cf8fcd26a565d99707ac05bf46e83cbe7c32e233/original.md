```julia
isfull(c::Channel)
```

Determines if a [`Channel`](@ref) is full, in the sense that calling `put!(c, some_value)` would have blocked. Returns immediately, does not block.

Note that it may frequently be the case that `put!` will not block after this returns `true`. Users must take precautions not to accidentally create live-lock bugs in their code by calling this method, as these are generally harder to debug than deadlocks. It is also possible that `put!` will block after this call returns `false`, if there are multiple producer tasks calling `put!` in parallel.

# Examples

Buffered channel:

```jldoctest
julia> c = Channel(1); # capacity = 1

julia> isfull(c)
false

julia> put!(c, 1);

julia> isfull(c)
true
```

Unbuffered channel:

```jldoctest
julia> c = Channel(); # capacity = 0

julia> isfull(c) # unbuffered channel is always full
true
```
