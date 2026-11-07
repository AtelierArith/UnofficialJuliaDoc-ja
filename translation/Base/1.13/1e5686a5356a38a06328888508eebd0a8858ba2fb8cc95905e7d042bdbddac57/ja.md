```julia
Timer(callback::Function, delay; interval = 0, spawn::Union{Nothing,Bool}=nothing)
```

タイマーが満了するたびに関数 `callback` を実行するタイマーを作成します。

最初に `delay` 秒の遅延を置いてから、待機中のタスクを起こし、関数 `callback` を呼び出します。その後は、指定された `interval` 秒の間隔でこれを繰り返します。`interval` が `0` と等しい場合、コールバックは一度だけ実行されます。関数 `callback` は、タイマー自体を唯一の引数として呼び出されます。タイマーを停止するには、`close` を呼び出します。ただし、タイマーがすでに満了している場合は、`callback` が最後にもう一度実行される可能性があります。

`spawn` が `true` の場合、作成されるタスクは spawn され、スレッド間の移動が許可されます。これにより、親タスクが現在のスレッドに固定されてしまうという副作用を回避できます。`spawn` が `nothing`（デフォルト）の場合、親タスクが sticky でなければ、そのタスクは spawn されます。

!!! compat "Julia 1.12"
    `spawn` 引数は Julia 1.12 で導入されました。


# Examples

この例では、2 秒の遅延後に最初の数値が出力され、その後、残りの数値がすばやく出力されます。

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
