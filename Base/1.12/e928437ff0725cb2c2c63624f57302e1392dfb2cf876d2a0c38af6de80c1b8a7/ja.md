```julia
pkgdir(m::Module[, paths::String...])
```

モジュール `m` を宣言したパッケージのルートディレクトリを返します。`m` がパッケージ内で宣言されていない場合は `nothing` を返します。オプションで、パッケージのルート内のパスを構成するために、さらにパスコンポーネントの文字列を提供できます。

現在のモジュールを実装しているパッケージのルートディレクトリを取得するには、`pkgdir(@__MODULE__)` の形式を使用できます。

拡張モジュールが指定された場合は、親パッケージのルートが返されます。

```julia-repl
julia> pkgdir(Foo)
"/path/to/Foo.jl"

julia> pkgdir(Foo, "src", "file.jl")
"/path/to/Foo.jl/src/file.jl"
```

他にも [`pathof`](@ref) を参照してください。

!!! compat "Julia 1.7"
    オプション引数 `paths` は少なくとも Julia 1.7 が必要です。

