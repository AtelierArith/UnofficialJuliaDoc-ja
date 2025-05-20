```
LibGit2.map(f::Function, walker::GitRevWalker; oid::GitHash=GitHash(), range::AbstractString="", by::Cint=Consts.SORT_NONE, rev::Bool=false)
```

Using the [`GitRevWalker`](@ref) `walker` to "walk" over every commit in the repository's history, apply `f` to each commit in the walk. The keyword arguments are:     * `oid`: The [`GitHash`](@ref) of the commit to begin the walk from. The default is to use       [`push_head!`](@ref) and therefore the HEAD commit and all its ancestors.     * `range`: A range of `GitHash`s in the format `oid1..oid2`. `f` will be       applied to all commits between the two.     * `by`: The sorting method. The default is not to sort. Other options are to sort by       topology (`LibGit2.Consts.SORT_TOPOLOGICAL`), to sort forwards in time       (`LibGit2.Consts.SORT_TIME`, most ancient first) or to sort backwards in time       (`LibGit2.Consts.SORT_REVERSE`, most recent first).     * `rev`: Whether to reverse the sorted order (for instance, if topological sorting is used).

# Examples

```julia
oids = LibGit2.with(LibGit2.GitRevWalker(repo)) do walker
    LibGit2.map((oid, repo)->string(oid), walker, by=LibGit2.Consts.SORT_TIME)
end
```

Here, `LibGit2.map` visits each commit using the `GitRevWalker` and finds its `GitHash`.
