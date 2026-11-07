```julia
Base.Splat{F} <: Function
```

スプラット関数を表します。つまり、

```julia
Base.Splat(f)(args) === f(args...)
```

`Base.Splat`のインスタンスを作成するには、[`splat`](@ref)関数を使うのが推奨されます。

!!! compat "Julia 1.9"
    Splatを使用するにはJulia 1.9以降が必要です。それ以前のバージョンでは、`splat`は無名関数を返します。


[`splat`](@ref)も参照してください。
