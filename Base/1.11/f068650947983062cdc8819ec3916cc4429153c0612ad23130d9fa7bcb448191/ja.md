```
Timer(callback::Function, delay; interval = 0)
```

関数 `callback` を各タイマーの期限切れ時に実行するタイマーを作成します。

待機中のタスクは起こされ、関数 `callback` は最初の遅延 `delay` 秒後に呼び出され、その後は指定された `interval` 秒ごとに繰り返し呼び出されます。`interval` が `0` の場合、コールバックは一度だけ実行されます。関数 `callback` は、タイマー自体を引数として一つ受け取って呼び出されます。タイマーを停止するには `close` を呼び出します。タイマーがすでに期限切れの場合、コールバックは最後に一度実行されることがあります。

# 例

ここでは、最初の数字が2秒の遅延の後に印刷され、その後の数字はすぐに印刷されます。

```julia-repl
julia> begin
           i = 0
           cb(timer) = (global i += 1; println(i))
           t = Timer(cb, 2, interval=0.2)
           wait(t)
           sleep(0.5)
           close(t)
       end
1
2
3
```
