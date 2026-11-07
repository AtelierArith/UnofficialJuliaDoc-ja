```julia
InterruptException()
```

ターミナルからの割り込み（CTRL+C）によって、プロセスが停止しました。

`-i`（対話モード）オプションを指定せずに起動した Julia スクリプトでは、デフォルトで `InterruptException` はスローされません。スクリプト内で [`Base.exit_on_sigint(false)`](@ref Base.exit_on_sigint) を呼び出すと、REPL と同じ動作に戻せます。あるいは、Julia スクリプトを次のように起動すると、

```sh
julia -e "include(popfirst!(ARGS))" script.jl
```

実行中に CTRL+C を押したときに `InterruptException` がスローされます。
