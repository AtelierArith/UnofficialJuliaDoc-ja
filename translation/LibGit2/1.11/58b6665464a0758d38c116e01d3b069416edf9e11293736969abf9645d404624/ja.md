```julia
GitTree(repo::GitRepo, hash::AbstractGitHash)
GitTree(repo::GitRepo, spec::AbstractString)
```

`repo`で指定された`hash`/`spec`から、`GitTree`オブジェクトを返します。

  * `hash`は、完全な（`GitHash`）ハッシュ、または部分的な（`GitShortHash`）ハッシュです。
  * `spec`はテキスト形式の指定です。全項目については[the git docs](https://git-scm.com/docs/git-rev-parse.html#_specifying_revisions)を参照してください。
