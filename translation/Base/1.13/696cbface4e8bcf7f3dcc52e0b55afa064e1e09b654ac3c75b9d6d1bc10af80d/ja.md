```julia
redirect_stdin(f::Function, stream)
```

[`stdin`](@ref) を `stream` にリダイレクトしながら、関数 `f` を実行します。完了後、[`stdin`](@ref) は元の設定に戻ります。
