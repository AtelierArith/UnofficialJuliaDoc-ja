```julia
notify(condition, val=nothing; all=true, error=false)
```

条件を待っているタスクを起こし、`val`を渡します。`all`が`true`（デフォルト）の場合は、待機中のタスクをすべて起こします。それ以外の場合は、1つだけ起こします。`error`が`true`の場合、渡された値は起こされたタスク内で例外として送出されます。

起こしたタスクの数を返します。`condition`で待機しているタスクがない場合は、0を返します。
