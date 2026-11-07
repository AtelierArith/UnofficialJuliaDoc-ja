```julia
isopen(c::Channel)
```

[`Channel`](@ref)が新しい[`put!`](@ref)操作を受け付ける状態かどうかを判定します。`Channel`は閉じていても、バッファに要素が残っており、[`take!`](@ref)で取り出せる場合があります。

# Examples

## Buffered channel with task

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

## Unbuffered channel

```jldoctest
julia> c = Channel{Int}();

julia> isopen(c)
true

julia> close(c)

julia> isopen(c)
false
```
