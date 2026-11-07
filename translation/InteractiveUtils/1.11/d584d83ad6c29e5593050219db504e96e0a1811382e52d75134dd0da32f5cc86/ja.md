```julia
@trace_dispatch
```

式を実行し、動的ディスパッチによってコンパイルされたメソッドを報告するマクロです。julia の引数 `--trace-dispatch=stderr` と同様ですが、特に関数呼び出しを対象とします。

!!! compat "Julia 1.12"
    このマクロを使用するには、Julia 1.12 以降が必要です。

