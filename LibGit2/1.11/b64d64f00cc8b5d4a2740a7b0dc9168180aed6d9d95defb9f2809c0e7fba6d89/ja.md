```julia
@githash_str -> AbstractGitHash
```

与えられた文字列から git ハッシュオブジェクトを構築し、文字列が 40 進数の桁数より短い場合は `GitShortHash` を、そうでない場合は `GitHash` を返します。

# 例

```jldoctest
julia> LibGit2.githash"d114feb74ce633"
GitShortHash("d114feb74ce633")

julia> LibGit2.githash"d114feb74ce63307afe878a5228ad014e0289a85"
GitHash("d114feb74ce63307afe878a5228ad014e0289a85")
```
