```julia
tryopen_exclusive(path::String, mode::Integer = 0o444) :: Union{Void, File}
```

読み書き用にアドバイザリ排他ロックを伴う新しいファイルの作成を試みます。ファイルがすでに存在する場合は nothing を返します。
