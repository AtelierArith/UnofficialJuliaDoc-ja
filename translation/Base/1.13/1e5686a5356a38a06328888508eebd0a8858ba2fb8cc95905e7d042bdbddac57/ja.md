```julia
Timer(callback::Function, delay; interval = 0, spawn::Union{Nothing,Bool}=nothing)
```

タイマーが満了するたびに関数 `callback` を実行するタイマーを作成します。

最初に `delay` 秒待った後、待機中のタスクが起こされ、関数 `callback` が呼び出されます。その後は、秒単位で指定された `interval` の間隔でこれを繰り返します。`interval` が `0` と等しい場合、コールバックは一度だけ実行されます。関数 `callback` は、タイマー自体を唯一の引数として呼び出されます。タイマーを停止するには `close` を呼び出します。ただし、タイマーがすでに満了している場合は、`callback` が最後にもう一度実行されることがあります。

`spawn` が `true` の場合、作成されたタスクは spawn されます。つまり、スレッド間の移動が許可されるため、親タスクが現在のスレッドに固定されてしまう副作用を回避できます。`spawn` が `nothing`（デフォルト）の場合、親タスクが sticky でなければ、タスクは spawn されます。

!!! compat "Julia 1.12"
    `spawn` 引数は Julia 1.12 で導入されました。


# Examples

ここでは、2 秒待ってから最初の数値が表示され、その後の数値はすぐに続けて表示されます。

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
