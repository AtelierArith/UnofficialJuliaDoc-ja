```julia
put!(rr::Future, v)
```

値を[`Future`](@ref) `rr`に格納します。`Future`は、一度だけ書き込み可能なリモート参照です。すでに設定済みの`Future`に対して`put!`を実行すると、`Exception`がスローされます。すべての非同期リモート呼び出しは`Future`を返し、完了時に呼び出しの戻り値を値として設定します。
