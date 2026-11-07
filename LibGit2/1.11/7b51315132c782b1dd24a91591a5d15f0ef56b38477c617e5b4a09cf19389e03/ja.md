```julia
fetchheads(repo::GitRepo)::Vector{FetchHead}
```

`repo` のすべてのフェッチヘッドを、それぞれ [`FetchHead`](@ref) として返してください。各フェッチヘッドには、名前、URL、マージ状態を含めてください。

# Examples

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
