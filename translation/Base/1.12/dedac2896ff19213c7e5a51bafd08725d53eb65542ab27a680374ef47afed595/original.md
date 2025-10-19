```julia
isready(c::Channel)
```

Determines whether a [`Channel`](@ref) has a value stored in it. Returns immediately, does not block.

For unbuffered channels, return `true` if there are tasks waiting on a [`put!`](@ref).

# Examples

Buffered channel:

```jldoctest
julia> c = Channel(1);

julia> isready(c)
false

julia> put!(c, 1);

julia> isready(c)
true
```

Unbuffered channel:

```jldoctest
julia> c = Channel();

julia> isready(c)  # no tasks waiting to put!
false

julia> task = Task(() -> put!(c, 1));

julia> schedule(task);  # schedule a put! task

julia> isready(c)
true
```
