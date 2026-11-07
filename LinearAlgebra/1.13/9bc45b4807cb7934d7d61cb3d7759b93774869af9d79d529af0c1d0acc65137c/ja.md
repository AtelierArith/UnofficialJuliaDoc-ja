```julia
eigen!(A; permute, scale, sortby)
eigen!(A, B; sortby)
```

[`eigen`](@ref)と同じですが、コピーを作成せずに入力`A`（および`B`）を上書きするため、メモリを節約できます。
