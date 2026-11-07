```julia
LibGit2.push!(w::GitRevWalker, cid::GitHash)
```

Start the [`GitRevWalker`](@ref) `walker` at commit `cid`. This function can be used to apply a function to all commits since a certain year, by passing the first commit of that year as `cid` and then passing the resulting `w` to [`LibGit2.map`](@ref).
