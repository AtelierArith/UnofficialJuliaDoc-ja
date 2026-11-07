```julia
wait(c::GenericCondition; first::Bool=false)
```

[`notify`](@ref)で`c`が発生するのを待ち、`notify`に渡された`val`パラメーターを返します。

キーワード`first`が`true`に設定されている場合、待機中のタスクは`notify`で最初に起こされるよう、待ち行列の先頭に置かれます。それ以外の場合、`wait`は先入れ先出し（FIFO）で動作します。
