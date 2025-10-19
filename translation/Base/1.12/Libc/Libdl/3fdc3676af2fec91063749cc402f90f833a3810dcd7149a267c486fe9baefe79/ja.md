```julia
dlsym_e(handle, sym)
```

共有ライブラリハンドルからシンボルを検索し、検索失敗時には静かに `C_NULL` を返します。このメソッドは現在、`dlsym(handle, sym; throw_error=false)` に代わって非推奨となっています。
