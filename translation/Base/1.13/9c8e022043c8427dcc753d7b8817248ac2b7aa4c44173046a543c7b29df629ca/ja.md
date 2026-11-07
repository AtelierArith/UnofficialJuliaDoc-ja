```julia
pathof(m::Module)
```

`m.jl` ファイルから `import` モジュール `m` が読み込まれた場合は、そのファイルのパスを返します。`m` がパッケージから読み込まれていない場合は、`nothing` を返します。

パスのディレクトリ部分を取得するには [`dirname`](@ref) を、ファイル名部分を取得するには [`basename`](@ref) を使います。

関連項目: [`pkgdir`](@ref)。
