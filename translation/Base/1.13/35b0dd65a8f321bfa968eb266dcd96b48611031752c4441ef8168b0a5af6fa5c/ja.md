```julia
redirect_stderr(f::Function, stream)
```

[`stderr`](@ref) を `stream` にリダイレクトしながら、関数 `f` を実行します。完了すると、[`stderr`](@ref) は以前の設定に戻ります。
