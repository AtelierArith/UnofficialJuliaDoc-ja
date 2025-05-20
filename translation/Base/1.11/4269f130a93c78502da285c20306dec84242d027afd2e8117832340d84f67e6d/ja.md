```
redirect_stdin(f::Function, stream)
```

関数 `f` を実行しながら [`stdin`](@ref) を `stream` にリダイレクトします。完了後、[`stdin`](@ref) は以前の設定に復元されます。
