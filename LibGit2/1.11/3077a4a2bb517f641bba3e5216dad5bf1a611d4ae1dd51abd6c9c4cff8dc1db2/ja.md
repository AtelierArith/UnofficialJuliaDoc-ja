```
@githash_str -> AbstractGitHash
```

与えられた文字列からgitハッシュオブジェクトを構築し、文字列が40の16進数桁未満の場合は`GitShortHash`を返し、それ以外の場合は`GitHash`を返します。

# 例

```jldoctest
julia> LibGit2.githash"d114feb74ce633"
GitShortHash("d114feb74ce633")

julia> LibGit2.githash"d114feb74ce63307afe878a5228ad014e0289a85"
GitHash("d114feb74ce63307afe878a5228ad014e0289a85")
```
