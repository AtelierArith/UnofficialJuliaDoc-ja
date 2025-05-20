```
wait(c::Channel)
```

`Channel` [`isready`](@ref) までブロックします。

```jldoctest
julia> c = Channel(1);

julia> isready(c)
false

julia> task = Task(() -> wait(c));

julia> schedule(task);

julia> istaskdone(task)  # タスクはチャネルが準備できていないためブロックされています
false

julia> put!(c, 1);

julia> istaskdone(task)  # タスクは今やブロック解除されました
true
```
