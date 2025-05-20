```
dlsym_e(handle, sym)
```

共有ライブラリハンドルからシンボルを検索し、検索に失敗した場合は静かに `C_NULL` を返します。このメソッドは、`dlsym(handle, sym; throw_error=false)` の代わりに非推奨となりました。
