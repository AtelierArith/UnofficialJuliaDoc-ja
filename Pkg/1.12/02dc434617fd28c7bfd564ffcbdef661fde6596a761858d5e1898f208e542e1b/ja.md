```julia
Pkg.compat()
```

現在のプロジェクト内の[compat]エントリを対話的に編集します。

```julia
Pkg.compat(pkg::String, compat::String)
```

現在のプロジェクト内の指定されたパッケージの[compat]文字列を設定します。

プロジェクトの[compat]セクションに関する詳細は[Compatibility](@ref)を参照してください。
