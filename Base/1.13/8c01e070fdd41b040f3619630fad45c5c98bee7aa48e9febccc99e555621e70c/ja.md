```julia
Base.generating_output([incremental::Bool])::Bool
```

現在のプロセスが、いずれかの `--output-*` コマンドライン引数を使ってコードキャッシュを事前生成している場合は、`true` を返します。省略可能な `incremental` 引数では、事前コンパイルのモードをさらに指定できます。`true` に設定すると、パッケージの事前コンパイル時に限り `true` を返します。`false` に設定すると、システムイメージの生成時に限り `true` を返します。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。

