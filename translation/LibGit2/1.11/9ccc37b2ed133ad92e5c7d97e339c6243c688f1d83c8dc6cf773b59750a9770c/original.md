```
GitObject(repo::GitRepo, hash::AbstractGitHash)
GitObject(repo::GitRepo, spec::AbstractString)
```

Return the specified object ([`GitCommit`](@ref), [`GitBlob`](@ref), [`GitTree`](@ref) or [`GitTag`](@ref)) from `repo` specified by `hash`/`spec`.

  * `hash` is a full (`GitHash`) or partial (`GitShortHash`) hash.
  * `spec` is a textual specification: see [the git docs](https://git-scm.com/docs/git-rev-parse.html#_specifying_revisions) for a full list.
