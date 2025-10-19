```julia
isfull(c::Channel)
```

[`Channel`](@ref) が満杯かどうかを判断します。つまり、`put!(c, some_value)` を呼び出すとブロックされることになります。即座に返し、ブロックしません。

このメソッドが `true` を返した後、`put!` がブロックされないことが頻繁にあることに注意してください。ユーザーは、このメソッドを呼び出すことでコードにライブロックバグを誤って作成しないように注意する必要があります。これらは一般的にデッドロックよりもデバッグが難しいです。また、複数のプロデューサタスクが並行して `put!` を呼び出している場合、この呼び出しが `false` を返した後に `put!` がブロックされる可能性もあります。

# 例

バッファ付きチャネル:

```jldoctest
julia> c = Channel(1); # capacity = 1

julia> isfull(c)
false

julia> put!(c, 1);

julia> isfull(c)
true
```

バッファなしチャネル:

```jldoctest
julia> c = Channel(); # capacity = 0

julia> isfull(c) # バッファなしチャネルは常に満杯
true
```
