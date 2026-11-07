```julia
notify(condition, val=nothing; all=true, error=false)
```

条件を待機しているタスクを起こし、`val`を渡します。`all`が`true`（デフォルト）の場合は待機中のすべてのタスクを起こし、それ以外の場合は1つだけを起こします。`error`が`true`の場合、渡された値は起こされたタスク内で例外として送出されます。

起こしたタスクの数を返します。`condition`を待機しているタスクがない場合は0を返します。
