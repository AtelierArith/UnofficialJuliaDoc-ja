```julia
redirect_stderr(f::Function, stream)
```

`f`関数を実行する際、[`stderr`](@ref)を`stream`にリダイレクトします。実行が完了すると、[`stderr`](@ref)は以前の設定に戻ります。
