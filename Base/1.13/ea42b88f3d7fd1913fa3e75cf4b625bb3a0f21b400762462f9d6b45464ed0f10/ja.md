```julia
isfull(c::Channel)
```

[`Channel`](@ref) が満杯かどうかを判定します。つまり、`put!(c, some_value)` を呼び出すとブロックされる状態かどうかを調べます。すぐに戻り、ブロックしません。

この呼び出しが `true` を返した後でも、`put!` がブロックしないことはよくあります。このメソッドを呼び出すことで、コードにライブロックが誤って発生しないよう、ユーザーは注意する必要があります。ライブロックは一般にデッドロックよりもデバッグが困難です。また、複数のプロデューサータスクが並行して `put!` を呼び出している場合、この呼び出しが `false` を返した後でも、`put!` がブロックする可能性があります。

# Examples

## Buffered channel

```jldoctest
julia> c = Channel(1); # capacity = 1

julia> isfull(c)
false

julia> put!(c, 1);

julia> isfull(c)
true
```

## Unbuffered channel

```jldoctest
julia> c = Channel(); # capacity = 0

julia> isfull(c) # unbuffered channel is always full
true
```
