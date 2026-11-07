```julia
dlsym_e(handle, sym)
```

共有ライブラリのハンドルからシンボルを検索し、見つからない場合はエラーを出さずに `C_NULL` を返します。このメソッドは非推奨となり、代わりに `dlsym(handle, sym; throw_error=false)` を使用してください。
