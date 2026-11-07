```julia
GitObject(repo::GitRepo, hash::AbstractGitHash)
GitObject(repo::GitRepo, spec::AbstractString)
```

`hash`/`spec`で指定された`repo`から、指定されたオブジェクト（[`GitCommit`](@ref)、[`GitBlob`](@ref)、[`GitTree`](@ref)、または[`GitTag`](@ref)）を返します。

  * `hash`は、完全な（`GitHash`）ハッシュ、または部分的な（`GitShortHash`）ハッシュです。
  * `spec`はテキスト形式の仕様です。全項目については[the git docs](https://git-scm.com/docs/git-rev-parse.html#_specifying_revisions)を参照してください。
