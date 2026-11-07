```julia
@threadcall((cfunc, clib), rettype, (argtypes...), argvals...)
```

`@threadcall` マクロは、[`ccall`](@ref) と同じ方法で呼び出しますが、処理は別のスレッドで実行されます。これにより、ブロッキングを伴う C 関数を呼び出しても、現在の `julia` スレッドがブロックされるのを防げます。同時実行数は libuv スレッドプールのサイズによって制限されます。スレッドプールのサイズはデフォルトで 4 ですが、`UV_THREADPOOL_SIZE` 環境変数を設定して `julia` プロセスを再起動すると増やせます。

呼び出す関数から Julia にコールバックしてはならない点に注意してください。
