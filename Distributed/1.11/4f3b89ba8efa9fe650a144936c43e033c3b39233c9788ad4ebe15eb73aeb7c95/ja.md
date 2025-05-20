```
remote([p::AbstractWorkerPool], f) -> Function
```

利用可能なワーカーで関数 `f` を実行する無名関数を返します（提供されている場合は [`WorkerPool`](@ref) `p` から取得） [`remotecall_fetch`](@ref) を使用して。
