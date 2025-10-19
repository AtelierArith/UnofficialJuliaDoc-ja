```julia
isopen(ctx::SSLContext)
```

`iswritable(ctx)`と同じです。

> "...閉じたストリームでも、そのバッファに読み取るデータが残っている可能性があるため、データを読み取る能力を確認するにはeofを使用してください。" [?Base.isopen]

