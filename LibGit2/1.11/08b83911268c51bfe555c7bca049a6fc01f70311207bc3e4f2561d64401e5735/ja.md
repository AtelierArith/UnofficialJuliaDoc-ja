```julia
update!(repo::GitRepo, files::AbstractString...)
update!(idx::GitIndex, files::AbstractString...)
```

インデックス `idx`（または `repo` のインデックス）内で、`files` によってパスが指定されたすべてのファイルを更新します。インデックス内の各ファイルの状態をディスク上の現在の状態に合わせ、ディスク上で削除されている場合はインデックスから削除し、それ以外の場合はオブジェクトデータベース内のエントリを更新します。
