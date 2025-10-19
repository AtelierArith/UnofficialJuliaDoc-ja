```julia
LibGit2.gitdir(repo::GitRepo)
```

`repo`の「git」ファイルの場所を返します：

  * 通常のリポジトリの場合、これは`.git`フォルダーの場所です。
  * ベアリポジトリの場合、これはリポジトリ自体の場所です。

[`workdir`](@ref)や[`path`](@ref)も参照してください。
