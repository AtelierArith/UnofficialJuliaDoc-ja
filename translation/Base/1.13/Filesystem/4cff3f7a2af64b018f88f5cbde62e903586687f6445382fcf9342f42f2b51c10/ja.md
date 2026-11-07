```julia
mktemp(f::Function, parent=tempdir())
```

[`mktemp(parent)`](@ref)の結果に`f`関数を適用し、完了後に一時ファイルを削除してください。

関連項目: [`mktempdir`](@ref)。
