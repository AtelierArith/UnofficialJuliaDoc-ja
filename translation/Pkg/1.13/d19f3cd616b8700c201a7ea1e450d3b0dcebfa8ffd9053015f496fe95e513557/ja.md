```julia
Pkg.compat()
```

現在のプロジェクトの [compat] エントリを対話形式で編集します。

```julia
Pkg.compat(pkg::String, compat::String)
```

現在のプロジェクトで、指定したパッケージの [compat] 文字列を設定します。

プロジェクトの [compat] セクションの詳細については、[Compatibility](@ref) を参照してください。
