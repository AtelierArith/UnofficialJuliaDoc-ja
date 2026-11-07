```julia
eigen!(A; permute, scale, sortby)
eigen!(A, B; sortby)
```

[`eigen`](@ref)と同じですが、コピーを作成せず、入力`A`（および`B`）を上書きすることで、メモリを節約します。
