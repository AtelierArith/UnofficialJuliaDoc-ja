```julia
apropos([io::IO=stdout], pattern::Union{AbstractString,Regex})
```

利用可能なdocstringのうち、`pattern`を含む項目を検索します。

`pattern`が文字列の場合、大文字と小文字は区別されません。検索結果は`io`に出力されます。

`apropos`は、クエリを二重引用符で囲めば、REPLのヘルプモードから呼び出せます。

```julia
help?> "pattern"
```

!!! compat "Julia 1.11"
    Julia 1.11以降では、`apropos`を使う前に、`REPL`標準ライブラリを読み込む必要があります。

