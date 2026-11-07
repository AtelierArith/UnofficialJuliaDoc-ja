```julia
@githash_str -> AbstractGitHash
```

指定された文字列から git ハッシュオブジェクトを構築します。文字列が40桁未満の16進数の場合は `GitShortHash` を返し、それ以外の場合は `GitHash` を返します。

# Examples

```jldoctest
julia> LibGit2.githash"d114feb74ce633"
GitShortHash("d114feb74ce633")

julia> LibGit2.githash"d114feb74ce63307afe878a5228ad014e0289a85"
GitHash("d114feb74ce63307afe878a5228ad014e0289a85")
```
