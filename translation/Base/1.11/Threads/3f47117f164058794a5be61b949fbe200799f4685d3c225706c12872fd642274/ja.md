```
Threads.maxthreadid() -> Int
```

Juliaプロセスで利用可能なスレッドの数（すべてのスレッドプールを通じて）の下限を取得します。これはアトミック取得セマンティクスを持ちます。結果は常に[`threadid()`](@ref)および`threadid(task)`（`maxthreadid`を呼び出す前に観察できたタスクに対して）以上になります。
