```julia
pkgdir(m::Module[, paths::String...])
```

モジュール `m` を宣言したパッケージのルートディレクトリを返します。`m` がパッケージ内で宣言されていない場合は、`nothing` を返します。パッケージのルート内のパスを構築するために、追加のパス要素文字列を指定することもできます。

現在のモジュールを実装するパッケージのルートディレクトリを取得するには、`pkgdir(@__MODULE__)` の形式を使用できます。

拡張モジュールを指定した場合は、親パッケージのルートが返されます。

```julia-repl
julia> pkgdir(Foo)
"/path/to/Foo.jl"

julia> pkgdir(Foo, "src", "file.jl")
"/path/to/Foo.jl/src/file.jl"
```

関連項目: [`pathof`](@ref)。

!!! compat "Julia 1.7"
    オプション引数 `paths` を使用するには、Julia 1.7 以降が必要です。

