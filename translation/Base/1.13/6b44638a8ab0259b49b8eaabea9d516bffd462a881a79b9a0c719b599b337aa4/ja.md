```julia
@threadcall((cfunc, clib), rettype, (argtypes...), argvals...)
```

`@threadcall` マクロは、[`ccall`](@ref) と同じ方法で呼び出しますが、処理は別のスレッドで行われます。これにより、ブロッキングを伴う C 関数を呼び出しても、現在の `julia` スレッドがブロックされるのを防げます。同時実行数は libuv スレッドプールのサイズによって制限されます。デフォルトは 4 スレッドですが、`UV_THREADPOOL_SIZE` 環境変数を設定して `julia` プロセスを再起動すれば、増やすことができます。

呼び出される関数から Julia を呼び出してはならない点に注意してください。
