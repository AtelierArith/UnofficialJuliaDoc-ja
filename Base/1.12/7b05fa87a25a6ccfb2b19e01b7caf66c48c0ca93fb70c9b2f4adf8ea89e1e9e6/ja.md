```julia
exit_on_sigint(on::Bool)
```

`exit_on_sigint` フラグを Julia ランタイムに設定します。 `false` の場合、Ctrl-C (SIGINT) は `try` ブロック内で [`InterruptException`](@ref) として捕捉可能です。これは REPL、`-e` および `-E` を介して実行されるコード、`-i` オプションで実行される Julia スクリプトのデフォルトの動作です。

`true` の場合、Ctrl-C によって `InterruptException` はスローされません。そのようなイベントに対してコードを実行するには [`atexit`](@ref) が必要です。これは `-i` オプションなしで実行される Julia スクリプトのデフォルトの動作です。

!!! compat "Julia 1.5"
    関数 `exit_on_sigint` は少なくとも Julia 1.5 を必要とします。

