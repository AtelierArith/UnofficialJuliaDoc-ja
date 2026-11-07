```julia
mktempdir(f::Function, parent=tempdir(); prefix="jl_")
```

[`mktempdir(parent; prefix)`](@ref) の結果に `f` 関数を適用し、完了後に一時ディレクトリとその内容をすべて削除します。

関連項目: [`mktemp`](@ref)、[`mkdir`](@ref)。

!!! compat "Julia 1.2"
    `prefix` キーワード引数は Julia 1.2 で追加されました。

