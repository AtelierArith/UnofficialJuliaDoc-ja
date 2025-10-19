```julia
dlsym(handle, sym; throw_error::Bool = true)
```

共有ライブラリハンドルからシンボルを検索し、成功した場合は呼び出し可能な関数ポインタを返します。

シンボルが見つからない場合、このメソッドはエラーをスローしますが、キーワード引数 `throw_error` が `false` に設定されている場合は、このメソッドは `nothing` を返します。
