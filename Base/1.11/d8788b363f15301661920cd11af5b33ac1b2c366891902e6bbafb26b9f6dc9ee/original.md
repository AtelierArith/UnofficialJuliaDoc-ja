```
take!(c::Channel)
```

Removes and returns a value from a [`Channel`](@ref) in order. Blocks until data is available. For unbuffered channels, blocks until a [`put!`](@ref) is performed by a different task.

# Examples

Buffered channel:

```jldoctest
julia> c = Channel(1);

julia> put!(c, 1);

julia> take!(c)
1
```

Unbuffered channel:

```jldoctest
julia> c = Channel(0);

julia> task = Task(() -> put!(c, 1));

julia> schedule(task);

julia> take!(c)
1
```
