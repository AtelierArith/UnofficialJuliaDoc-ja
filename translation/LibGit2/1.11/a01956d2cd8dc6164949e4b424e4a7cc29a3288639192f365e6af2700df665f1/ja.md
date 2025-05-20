```
fetchheads(repo::GitRepo) -> Vector{FetchHead}
```

`repo`のすべてのフェッチヘッドのリストを返します。各フェッチヘッドは[`FetchHead`](@ref)として表され、その名前、URL、およびマージステータスが含まれます。

# 例

```julia-repl
julia> fetch_heads = LibGit2.fetchheads(repo);

julia> fetch_heads[1].name
"refs/heads/master"

julia> fetch_heads[1].ismerge
true

julia> fetch_heads[2].name
"refs/heads/test_branch"

julia> fetch_heads[2].ismerge
false
```
