```
tryopen_exclusive(path::String, mode::Integer = 0o444) :: Union{Void, File}
```

新しいファイルを読み書きのアドバイザリー排他アクセス用に作成しようとし、既に存在する場合は何も返さない。
