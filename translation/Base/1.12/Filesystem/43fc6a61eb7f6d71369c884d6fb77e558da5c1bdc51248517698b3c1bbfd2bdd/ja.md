```julia
mktemp(f::Function, parent=tempdir())
```

関数 `f` を [`mktemp(parent)`](@ref) の結果に適用し、完了後に一時ファイルを削除します。

参照: [`mktempdir`](@ref).
