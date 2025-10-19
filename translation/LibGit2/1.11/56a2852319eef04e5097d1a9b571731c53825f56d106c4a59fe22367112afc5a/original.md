```julia
GitTree(repo::GitRepo, hash::AbstractGitHash)
GitTree(repo::GitRepo, spec::AbstractString)
```

Return a `GitTree` object from `repo` specified by `hash`/`spec`.

  * `hash` is a full (`GitHash`) or partial (`GitShortHash`) hash.
  * `spec` is a textual specification: see [the git docs](https://git-scm.com/docs/git-rev-parse.html#_specifying_revisions) for a full list.
