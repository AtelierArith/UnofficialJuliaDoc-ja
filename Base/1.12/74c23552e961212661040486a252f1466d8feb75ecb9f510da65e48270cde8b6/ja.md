```julia
redirect_stderr(f::Function, stream)
```

関数 `f` を実行しながら [`stderr`](@ref) を `stream` にリダイレクトします。完了後、[`stderr`](@ref) は以前の設定に戻されます。
