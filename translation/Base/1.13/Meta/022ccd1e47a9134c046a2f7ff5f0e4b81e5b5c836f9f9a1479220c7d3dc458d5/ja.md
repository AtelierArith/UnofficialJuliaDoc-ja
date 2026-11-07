```julia
replace_sourceloc!(location, expr)
```

`expr` 内の各マクロ呼び出しについて、呼び出し元のソース位置を上書きし、その結果の AST を返します。マクロの中に別のマクロをラップし、内側のマクロに外側のマクロの `__source__` 位置を認識させたい場合に便利です。たとえば、次のようになります。

```julia
macro test_is_one(ex)
    replace_sourceloc!(__source__, :(@test $(esc(ex)) == 1))
end
@test_is_one 2
```

`@test` は、実装の詳細として `@test` が使われている2行目ではなく、呼び出し `@test_is_one 2` の位置をユーザーに報告するようになります。
