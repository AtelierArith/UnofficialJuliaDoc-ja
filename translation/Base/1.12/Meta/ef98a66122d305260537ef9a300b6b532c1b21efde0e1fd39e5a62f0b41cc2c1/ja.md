```julia
Meta.isexpr(ex, head[, n])::Bool
```

`ex` が指定された型 `head` の `Expr` であり、オプションで引数リストの長さが `n` である場合に `true` を返します。`head` は `Symbol` または `Symbol` のコレクションである可能性があります。たとえば、マクロに関数呼び出し式が渡されたかどうかを確認するには、`isexpr(ex, :call)` を使用することができます。

# 例

```jldoctest
julia> ex = :(f(x))
:(f(x))

julia> Meta.isexpr(ex, :block)
false

julia> Meta.isexpr(ex, :call)
true

julia> Meta.isexpr(ex, [:block, :call]) # 複数の可能なヘッド
true

julia> Meta.isexpr(ex, :call, 1)
false

julia> Meta.isexpr(ex, :call, 2)
true
```
