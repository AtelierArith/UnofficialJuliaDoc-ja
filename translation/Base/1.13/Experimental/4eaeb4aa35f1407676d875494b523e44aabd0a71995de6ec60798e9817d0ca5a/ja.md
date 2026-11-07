```julia
wait_with_timeout(c::GenericCondition; first::Bool=false, timeout::Real=0.0)
```

`c`上で[`notify`](@ref)を待機し、`notify`に渡された`val`パラメーターを返します。

キーワード`first`が`true`に設定されている場合、待機中のタスクは`notify`で最初に起こされるよう、待ち行列の先頭に置かれます。それ以外の場合、`wait`は先入れ先出し（FIFO）で動作します。

`timeout`が指定されている場合、期限が切れたときに`wait`をキャンセルし、`:timed_out`を返します。`timeout`の最小値は0.001秒（1ミリ秒）です。
