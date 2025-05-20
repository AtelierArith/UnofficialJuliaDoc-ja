```
GitTag(repo::GitRepo, hash::AbstractGitHash)
GitTag(repo::GitRepo, spec::AbstractString)
```

`hash`/`spec`で指定された`repo`から`GitTag`オブジェクトを返します。

  * `hash`はフル（`GitHash`）または部分（`GitShortHash`）のハッシュです。
  * `spec`はテキスト仕様です：完全なリストについては[gitドキュメント](https://git-scm.com/docs/git-rev-parse.html#_specifying_revisions)を参照してください。
