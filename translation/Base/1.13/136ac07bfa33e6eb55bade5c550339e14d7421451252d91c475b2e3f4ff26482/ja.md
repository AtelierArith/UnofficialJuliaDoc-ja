```julia
take!(c::Channel)
```

[`Channel`](@ref)から順番に値を取り出して返します。データが利用可能になるまでブロックします。バッファなしチャネルの場合は、別のタスクによって[`put!`](@ref)が実行されるまでブロックします。

# Examples

## Buffered channel

```jldoctest
julia> c = Channel(1);

julia> put!(c, 1);

julia> take!(c)
1
```

## Unbuffered channel

```jldoctest
julia> c = Channel(0);

julia> task = Task(() -> put!(c, 1));

julia> schedule(task);

julia> take!(c)
1
```
