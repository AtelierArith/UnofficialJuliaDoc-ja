```julia
Meta.isexpr(ex, head[, n])::Bool
```

`ex`が指定された型`head`の`Expr`であり、さらに引数リストの長さが`n`であることを任意で確認したうえで、`true`を返します。`head`には、`Symbol`または`Symbol`のコレクションを指定できます。たとえば、マクロに関数呼び出し式が渡されたことを確認するには、`isexpr(ex, :call)`を使用します。

# Examples

```jldoctest
julia> ex = :(f(x))
:(f(x))

julia> Meta.isexpr(ex, :block)
false

julia> Meta.isexpr(ex, :call)
true

julia> Meta.isexpr(ex, [:block, :call]) # multiple possible heads
true

julia> Meta.isexpr(ex, :call, 1)
false

julia> Meta.isexpr(ex, :call, 2)
true
```
