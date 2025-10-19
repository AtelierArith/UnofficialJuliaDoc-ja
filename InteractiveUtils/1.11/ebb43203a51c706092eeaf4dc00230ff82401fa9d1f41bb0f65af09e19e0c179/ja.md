```julia
@trace_dispatch
```

式を実行し、動的ディスパッチを介してコンパイルされたメソッドを報告するマクロで、julia引数`--trace-dispatch=stderr`に似ていますが、特定の呼び出しに対してです。

!!! compat "Julia 1.12"
    このマクロは少なくともJulia 1.12が必要です。

