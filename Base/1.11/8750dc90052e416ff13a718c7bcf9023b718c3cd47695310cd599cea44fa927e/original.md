```
wait(c::Channel)
```

Blocks until the `Channel` [`isready`](@ref).

```jldoctest
julia> c = Channel(1);

julia> isready(c)
false

julia> task = Task(() -> wait(c));

julia> schedule(task);

julia> istaskdone(task)  # task is blocked because channel is not ready
false

julia> put!(c, 1);

julia> istaskdone(task)  # task is now unblocked
true
```
