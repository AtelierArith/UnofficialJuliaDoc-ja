```julia
Docs.doc(binding, sig)
```

`binding`と`sig`の両方に一致するドキュメントをすべて返します。

`getdoc`が、バインディングの値に対して`nothing`以外の結果を返す場合、バインディング自体に基づくものではなく、動的なdocstringが返されます。

!!! compat "Julia 1.11"
    Julia 1.11以降では、`Docs.doc`を使用するには、`REPL`標準ライブラリが読み込まれている必要があります。

