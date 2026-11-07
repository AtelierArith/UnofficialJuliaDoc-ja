```julia
GitBlame(repo::GitRepo, path::AbstractString; options::BlameOptions=BlameOptions())
```

Construct a `GitBlame` object for the file at `path`, using change information gleaned from the history of `repo`. The `GitBlame` object records who changed which chunks of the file when, and how. `options` controls how to separate the contents of the file and which commits to probe - see [`BlameOptions`](@ref) for more information.
