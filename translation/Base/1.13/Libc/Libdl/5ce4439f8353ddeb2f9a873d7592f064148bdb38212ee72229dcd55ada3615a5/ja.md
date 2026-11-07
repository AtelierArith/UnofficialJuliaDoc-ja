```julia
dlsym(handle, sym; throw_error::Bool = true)
```

共有ライブラリのハンドルからシンボルを検索し、成功した場合は呼び出し可能な関数ポインターを返します。

シンボルが見つからない場合、このメソッドはエラーをスローします。ただし、キーワード引数`throw_error`が`false`に設定されている場合は、`nothing`を返します。
