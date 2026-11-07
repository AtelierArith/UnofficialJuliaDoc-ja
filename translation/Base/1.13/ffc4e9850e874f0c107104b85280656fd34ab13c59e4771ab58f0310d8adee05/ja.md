```julia
current_exceptions(task::Task=current_task(); [backtrace::Bool=true])
```

現在処理中の例外スタックを取得します。入れ子になった catch ブロックでは、現在の例外が複数存在する場合があります。その場合、最後にスローされた例外がスタックの末尾にあります。スタックは、名前付きタプル `(exception,backtrace)` の AbstractVector である `ExceptionStack` として返されます。`backtrace` が false の場合、各ペアのバックトレースは `nothing` に設定されます。

`task` を明示的に渡すと、任意のタスクの現在の例外スタックを取得できます。これは、捕捉されない例外によって失敗したタスクを調べるのに便利です。

!!! compat "Julia 1.7"
    この関数は Julia 1.1～1.6 では実験的な名前 `catch_stack()` で呼ばれており、戻り値の型は単純なタプルの Vector でした。

