```julia
wait(c::GenericCondition; first::Bool=false)
```

`c`での[`notify`](@ref)を待機し、`notify`に渡された`val`パラメータを返します。

キーワード`first`が`true`に設定されている場合、待機者は`notify`で起こされるための*最初*の位置に置かれます。そうでない場合、`wait`は先入れ先出し（FIFO）の動作をします。
