```julia
InterruptException()
```

ターミナルからの割り込み（CTRL+C）によって、プロセスが停止しました。

`-i`（対話モード）を指定せずに起動したJuliaスクリプトでは、デフォルトで`InterruptException`はスローされません。スクリプト内で[`Base.exit_on_sigint(false)`](@ref Base.exit_on_sigint)を呼び出すと、REPLと同じ動作に戻せます。あるいは、Juliaスクリプトを次のように起動すると、

```sh
julia -e "include(popfirst!(ARGS))" script.jl
```

実行中にCTRL+Cを押したときに`InterruptException`がスローされます。
