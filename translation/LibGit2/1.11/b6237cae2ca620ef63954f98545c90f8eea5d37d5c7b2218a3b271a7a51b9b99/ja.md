```julia
update!(repo::GitRepo, files::AbstractString...)
update!(idx::GitIndex, files::AbstractString...)
```

`files` で指定されたパスのすべてのファイルをインデックス `idx` (または `repo` のインデックス) で更新します。インデックス内の各ファイルの状態をディスク上の現在の状態と一致させ、ディスク上で削除されている場合はそれを削除し、オブジェクトデータベース内のエントリを更新します。
