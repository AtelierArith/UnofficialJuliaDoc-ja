```
fetch(c::Channel)
```

`Channel`から最初に利用可能なアイテムを待機して返します（削除せずに）。注意: `fetch`はバッファなし（サイズ0）の`Channel`ではサポートされていません。

# 例

バッファ付きチャネル:

```jldoctest
julia> c = Channel(3) do ch
           foreach(i -> put!(ch, i), 1:3)
       end;

julia> fetch(c)
1

julia> collect(c)  # アイテムは削除されません
3-element Vector{Any}:
 1
 2
 3
```
