```julia
@lock l expr
```

`f` 関数の代わりに `expr` を使う、`lock(f, l::AbstractLock)` のマクロ版です。次のように展開されます。

```julia
lock(l)
try
    expr
finally
    unlock(l)
end
```

これは、`do` ブロックを使って [`lock`](@ref) を使う方法に似ていますが、クロージャの作成を避けられるため、パフォーマンスが向上する場合があります。

!!! compat
    `@lock` は Julia 1.3 で追加され、Julia 1.7 でエクスポートされました。

