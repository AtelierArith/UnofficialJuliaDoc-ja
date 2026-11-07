```julia
@trace_dispatch
```

式を実行し、動的ディスパッチによってコンパイルされたメソッドを報告するマクロです。Julia の引数 `--trace-dispatch=stderr` と同様ですが、特に呼び出しを対象とします。

!!! compat "Julia 1.12"
    このマクロを使用するには、Julia 1.12 以降が必要です。

