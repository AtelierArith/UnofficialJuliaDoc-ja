```julia
update!(repo::GitRepo, files::AbstractString...)
update!(idx::GitIndex, files::AbstractString...)
```

`files`で指定されたパスを持つすべてのファイルを、`idx`のインデックス（または`repo`のインデックス）で更新します。インデックス内の各ファイルの状態をディスク上の現在の状態と一致させます。ディスク上で削除されているファイルはインデックスから削除し、それ以外のファイルはオブジェクトデータベース内のエントリを更新します。
