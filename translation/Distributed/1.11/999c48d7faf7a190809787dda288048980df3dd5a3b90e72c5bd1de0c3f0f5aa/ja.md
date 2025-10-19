```julia
put!(rr::Future, v)
```

[`Future`](@ref) `rr` に値を格納します。`Future` は一度だけ書き込むことができるリモート参照です。すでに設定された `Future` に対して `put!` を行うと `Exception` がスローされます。すべての非同期リモート呼び出しは `Future` を返し、完了時に呼び出しの戻り値に値を設定します。
