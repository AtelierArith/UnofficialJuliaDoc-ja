```julia
exit_on_sigint(on::Bool)
```

Julia ランタイムの `exit_on_sigint` フラグを設定します。`false` の場合、Ctrl-C（SIGINT）は `try` ブロック内で [`InterruptException`](@ref) として捕捉できます。これは、REPL、`-e` および `-E` を使って実行するコード、ならびに `-i` オプションを指定して実行する Julia スクリプトでのデフォルトの動作です。

`true` の場合、Ctrl-C によって `InterruptException` はスローされません。このイベント発生時にコードを実行するには、[`atexit`](@ref) が必要です。これは、`-i` オプションを指定せずに実行する Julia スクリプトでのデフォルトの動作です。

!!! compat "Julia 1.5"
    関数 `exit_on_sigint` を使用するには、Julia 1.5 以降が必要です。

