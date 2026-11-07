```julia
isready(c::Channel)
```

[`Channel`](@ref)に値が格納されているかどうかを判定します。ブロックせず、すぐに戻ります。

バッファなしチャネルの場合、[`put!`](@ref)で待機中のタスクがあれば、`true`を返します。

# Examples

## Buffered channel

```jldoctest
julia> c = Channel(1);

julia> isready(c)
false

julia> put!(c, 1);

julia> isready(c)
true
```

## Unbuffered channel

```jldoctest
julia> c = Channel();

julia> isready(c)  # no tasks waiting to put!
false

julia> task = Task(() -> put!(c, 1));

julia> schedule(task);  # schedule a put! task

julia> isready(c)
true
```
