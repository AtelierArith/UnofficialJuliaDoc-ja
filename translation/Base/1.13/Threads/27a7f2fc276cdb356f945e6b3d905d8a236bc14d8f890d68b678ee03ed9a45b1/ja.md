```julia
Threads.maxthreadid()::Int
```

アトミック取得セマンティクスで、Juliaプロセスが利用できるスレッド数（すべてのスレッドプールの合計）の下限を取得します。結果は、[`threadid()`](@ref)以上であり、`maxthreadid`を呼び出す前に観測できた任意のタスクについて、常に`threadid(task)`以上になります。
