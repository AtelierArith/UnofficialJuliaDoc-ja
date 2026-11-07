```julia
GitShortHash(hash::GitHash, len::Integer)
```

一意に識別できる場合に Git オブジェクトの識別に使用できる、短縮形の Git オブジェクト識別子。`hash` の先頭 `len` 桁の 16 進数で構成されます（残りの桁は無視されます）。
