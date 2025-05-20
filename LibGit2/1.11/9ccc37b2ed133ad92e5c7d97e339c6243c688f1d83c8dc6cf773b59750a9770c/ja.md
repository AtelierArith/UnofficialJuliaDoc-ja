```
GitObject(repo::GitRepo, hash::AbstractGitHash)
GitObject(repo::GitRepo, spec::AbstractString)
```

指定されたオブジェクト（[`GitCommit`](@ref), [`GitBlob`](@ref), [`GitTree`](@ref) または [`GitTag`](@ref)）を、`hash`/`spec`で指定された`repo`から返します。

  * `hash`はフル（`GitHash`）または部分（`GitShortHash`）のハッシュです。
  * `spec`はテキスト仕様です：完全なリストについては[gitドキュメント](https://git-scm.com/docs/git-rev-parse.html#_specifying_revisions)を参照してください。
