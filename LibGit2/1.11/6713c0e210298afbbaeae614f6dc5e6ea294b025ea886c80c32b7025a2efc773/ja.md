```
remove!(repo::GitRepo, files::AbstractString...)
remove!(idx::GitIndex, files::AbstractString...)
```

`files` で指定されたパスのすべてのファイルを、インデックス `idx` (または `repo` のインデックス) から削除します。
