```julia
fetch(c::Channel)
```

`Channel` から最初に利用可能な項目を待ち受け、削除せずに返します。注: バッファリングされていない（サイズ 0 の）`Channel` では、`fetch` はサポートされていません。

# Examples

## Buffered channel

```jldoctest
julia> c = Channel(3) do ch
           foreach(i -> put!(ch, i), 1:3)
       end;

julia> fetch(c)
1

julia> collect(c)  # item is not removed
3-element Vector{Any}:
 1
 2
 3
```
