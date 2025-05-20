```
GitCommit(repo::GitRepo, hash::AbstractGitHash)
GitCommit(repo::GitRepo, spec::AbstractString)
```

`hash`/`spec`で指定された`repo`から`GitCommit`オブジェクトを返します。

  * `hash`はフル（`GitHash`）または部分（`GitShortHash`）のハッシュです。
  * `spec`はテキスト仕様です：完全なリストについては[the git docs](https://git-scm.com/docs/git-rev-parse.html#_specifying_revisions)を参照してください。
