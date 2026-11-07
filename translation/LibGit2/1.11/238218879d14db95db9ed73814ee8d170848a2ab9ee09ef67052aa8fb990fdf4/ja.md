```julia
GitBlob(repo::GitRepo, hash::AbstractGitHash)
GitBlob(repo::GitRepo, spec::AbstractString)
```

`GitBlob` オブジェクトを、`repo` の中から `hash`/`spec` で指定して返します。

  * `hash` は、完全な（`GitHash`）ハッシュ、または部分的な（`GitShortHash`）ハッシュです。
  * `spec` はテキスト形式の仕様です。全項目については [the git docs](https://git-scm.com/docs/git-rev-parse.html#_specifying_revisions) を参照してください。
