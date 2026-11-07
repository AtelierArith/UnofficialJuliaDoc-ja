```julia
LibGit2.gitdir(repo::GitRepo)
```

`repo` の「git」ファイルの場所を返します。

  * 通常のリポジトリでは、`.git` フォルダーの場所です。
  * ベアリポジトリでは、リポジトリ自体の場所です。

[`workdir`](@ref)、[`path`](@ref) も参照してください。
