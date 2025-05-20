```
eigen!(A; permute, scale, sortby)
eigen!(A, B; sortby)
```

[`eigen`](@ref) と同様ですが、コピーを作成するのではなく、入力 `A`（および `B`）を上書きすることでスペースを節約します。
