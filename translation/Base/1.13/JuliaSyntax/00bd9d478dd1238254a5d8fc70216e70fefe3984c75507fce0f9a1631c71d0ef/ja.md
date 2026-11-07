```julia
@isexpr(ex, head)
@isexpr(ex, head, nargs)
```

`Meta.isexpr`の型推論に適した代替手段。

次のパターンを使う場合

```julia
if @isexpr(ex, headsym)
    body
end
```

Juliaの型推論は、`body`内の`ex isa Expr`を認識します。しかし、何らかの理由で`Meta.isexpr`はこの情報をコンパイラから隠してしまいます。
