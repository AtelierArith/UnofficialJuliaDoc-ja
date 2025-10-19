```julia
tryopen_exclusive(path::String, mode::Integer = 0o444) :: Union{Void, File}
```

読み書きの助言的排他アクセスのために新しいファイルを作成しようとし、既に存在する場合は何も返さない。
