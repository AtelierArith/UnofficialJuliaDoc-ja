```julia
Threads.maxthreadid() -> Int
```

Juliaプロセスで利用可能なスレッドの数（すべてのスレッドプールを通じて）の下限を取得します。これは、アトミック取得セマンティクスを持ちます。結果は常に[`threadid()`](@ref)および`threadid(task)`（`maxthreadid`を呼び出す前に観察できた任意のタスクに対して）以上になります。
