```julia
isopen(c::Channel)
```

新しい [`put!`](@ref) 操作のために [`Channel`](@ref) が開いているかどうかを判断します。`Channel` は閉じていても、[`take!`](@ref) で消費できるバッファされた要素を持っている可能性があることに注意してください。

# 例

タスクを持つバッファ付きチャネル:

```jldoctest
julia> c = Channel(ch -> put!(ch, 1), 1);

julia> isopen(c) # チャネルは新しい `put!` に対して閉じています
false

julia> isready(c) # チャネルは閉じていますが、まだ要素を含んでいます
true

julia> take!(c)
1

julia> isready(c)
false
```

バッファなしチャネル:

```jldoctest
julia> c = Channel{Int}();

julia> isopen(c)
true

julia> close(c)

julia> isopen(c)
false
```
