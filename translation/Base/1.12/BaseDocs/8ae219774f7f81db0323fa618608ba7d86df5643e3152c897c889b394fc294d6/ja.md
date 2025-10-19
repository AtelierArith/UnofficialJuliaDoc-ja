```julia
InterruptException()
```

プロセスはターミナルの中断（CTRL+C）によって停止されました。

`-i`（インタラクティブ）オプションなしで開始されたJuliaスクリプトでは、`InterruptException`はデフォルトではスローされないことに注意してください。スクリプト内で[`Base.exit_on_sigint(false)`](@ref Base.exit_on_sigint)を呼び出すことで、REPLの動作を回復できます。あるいは、次のようにJuliaスクリプトを開始することもできます。

```sh
julia -e "include(popfirst!(ARGS))" script.jl
```

これにより、実行中にCTRL+Cによって`InterruptException`がスローされるようになります。
