```julia
redirect_stdout(f::Function, stream)
```

`f`関数の実行中、[`stdout`](@ref)を`stream`にリダイレクトします。実行が完了すると、[`stdout`](@ref)は元の設定に戻ります。
