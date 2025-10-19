```julia
isopen(c::Channel)
```

Determines whether a [`Channel`](@ref) is open for new [`put!`](@ref) operations. Notice that a `Channel``can be closed and still have buffered elements which can be consumed with [`take!`](@ref).

# Examples

Buffered channel with task:

```jldoctest
julia> c = Channel(ch -> put!(ch, 1), 1);

julia> isopen(c) # The channel is closed to new `put!`s
false

julia> isready(c) # The channel is closed but still contains elements
true

julia> take!(c)
1

julia> isready(c)
false
```

Unbuffered channel:

```jldoctest
julia> c = Channel{Int}();

julia> isopen(c)
true

julia> close(c)

julia> isopen(c)
false
```
