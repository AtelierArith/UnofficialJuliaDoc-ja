```julia
tryopen_exclusive(path::String, mode::Integer = 0o444) :: Union{Void, File}
```

読み書き可能なアドバイザリ排他アクセス用に新しいファイルの作成を試み、すでに存在する場合は nothing を返します。
