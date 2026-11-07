```julia
remove!(repo::GitRepo, files::AbstractString...)
remove!(idx::GitIndex, files::AbstractString...)
```

インデックス `idx`（または `repo` のインデックス）から、`files` で指定されたパスのファイルをすべて削除します。
