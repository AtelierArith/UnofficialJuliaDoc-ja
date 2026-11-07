```julia
ISA(features::Set{UInt32})
```

コンピューターの命令セットアーキテクチャ（ISA）を表す構造体です。CPUの機能の`Set`を保持します。

各機能の数値は、JuliaのCソースコードから自動生成され、`features_h.jl` Juliaファイルに保存されます。
