```julia
LibGit2.count(f::Function, walker::GitRevWalker; oid::GitHash=GitHash(), by::Cint=Consts.SORT_NONE, rev::Bool=false)
```

Using the [`GitRevWalker`](@ref) `walker` to "walk" over every commit in the repository's history, find the number of commits which return `true` when `f` is applied to them. The keyword arguments are:     * `oid`: The [`GitHash`](@ref) of the commit to begin the walk from. The default is to use       [`push_head!`](@ref) and therefore the HEAD commit and all its ancestors.     * `by`: The sorting method. The default is not to sort. Other options are to sort by       topology (`LibGit2.Consts.SORT_TOPOLOGICAL`), to sort forwards in time       (`LibGit2.Consts.SORT_TIME`, most ancient first) or to sort backwards in time       (`LibGit2.Consts.SORT_REVERSE`, most recent first).     * `rev`: Whether to reverse the sorted order (for instance, if topological sorting is used).

# Examples

```julia
cnt = LibGit2.with(LibGit2.GitRevWalker(repo)) do walker
    LibGit2.count((oid, repo)->(oid == commit_oid1), walker, oid=commit_oid1, by=LibGit2.Consts.SORT_TIME)
end
```

`LibGit2.count` finds the number of commits along the walk with a certain `GitHash` `commit_oid1`, starting the walk from that commit and moving forwards in time from it. Since the `GitHash` is unique to a commit, `cnt` will be `1`.
