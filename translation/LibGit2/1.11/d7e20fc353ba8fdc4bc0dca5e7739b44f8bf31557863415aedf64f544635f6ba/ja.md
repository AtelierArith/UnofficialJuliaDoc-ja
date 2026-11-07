```julia
remove!(repo::GitRepo, files::AbstractString...)
remove!(idx::GitIndex, files::AbstractString...)
```

インデックス `idx`（または `repo` のインデックス）で指定されているパスのファイルをすべて削除します。 `files`
