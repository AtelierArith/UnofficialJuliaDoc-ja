```julia
notify(condition, val=nothing; all=true, error=false)
```

条件を待っているタスクを起こし、`val`を渡します。`all`が`true`（デフォルト）であれば、すべての待機中のタスクが起こされ、そうでなければ1つだけが起こされます。`error`が`true`であれば、渡された値が起こされたタスクで例外として発生します。

起こされたタスクの数を返します。`condition`で待機中のタスクがない場合は0を返します。
