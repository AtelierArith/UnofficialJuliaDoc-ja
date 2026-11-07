```julia
deregister_auth_error_handler(urlscheme::Union{AbstractString, Regex}, f)
```

認証エラーハンドラーのスタックから`f`を削除します。
