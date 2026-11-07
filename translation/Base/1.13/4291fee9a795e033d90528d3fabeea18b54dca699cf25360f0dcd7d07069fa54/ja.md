```julia
release(s::Semaphore)
```

permitを1つプールに返却します。これにより、別のタスクがpermitを取得して実行を再開できる場合があります。
