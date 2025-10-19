```julia
current_exceptions(task::Task=current_task(); [backtrace::Bool=true])
```

現在処理中の例外のスタックを取得します。ネストされたキャッチブロックがある場合、現在の例外が複数存在する可能性があり、その場合、最も最近スローされた例外がスタックの最後にあります。スタックは `ExceptionStack` として返され、これは名前付きタプル `(exception,backtrace)` の AbstractVector です。`backtrace` が false の場合、各ペアのバックトレースは `nothing` に設定されます。

`task` を明示的に渡すことで、任意のタスクの現在の例外スタックを返します。これは、未処理の例外によって失敗したタスクを調査するのに便利です。

!!! compat "Julia 1.7"
    この関数は、Julia 1.1–1.6 では実験的な名前 `catch_stack()` で呼ばれており、戻り値の型は単純なタプルのベクターでした。

