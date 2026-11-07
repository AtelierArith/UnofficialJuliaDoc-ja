```julia
write_tree!(idx::GitIndex)::GitHash
```

インデックス `idx` を [`GitTree`](@ref) としてディスクに書き込みます。`idx` 内の各サブツリーに対して、ツリーが再帰的に作成されます。返された [`GitHash`](@ref) を使って [`GitCommit`](@ref) を作成できます。`idx` には親リポジトリが必要で、そのリポジトリはベアであってはなりません。`idx` に競合のあるファイルが含まれていてはなりません。
