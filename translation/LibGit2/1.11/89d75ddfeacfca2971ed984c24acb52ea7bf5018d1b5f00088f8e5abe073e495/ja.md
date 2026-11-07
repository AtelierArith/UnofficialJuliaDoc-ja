```julia
GitCommit(repo::GitRepo, hash::AbstractGitHash)
GitCommit(repo::GitRepo, spec::AbstractString)
```

`hash`/`spec`で指定された`repo`から、`GitCommit`オブジェクトを返します。

  * `hash`は、完全なハッシュ（`GitHash`）または部分ハッシュ（`GitShortHash`）です。
  * `spec`はテキスト形式の仕様です。全項目については[the git docs](https://git-scm.com/docs/git-rev-parse.html#_specifying_revisions)を参照してください。
