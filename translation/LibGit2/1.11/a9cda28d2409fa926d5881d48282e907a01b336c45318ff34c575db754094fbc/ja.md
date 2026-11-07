```julia
GitRevWalker(repo::GitRepo)
```

`GitRevWalker` は、Git リポジトリ `repo` の *リビジョン*（つまりコミット）を順にたどります。これはリポジトリ内のコミットを集めたもので、反復処理に対応しているほか、[`LibGit2.map`](@ref) や [`LibGit2.count`](@ref) を呼び出せます（たとえば `LibGit2.count` を使えば、特定の作者がリポジトリ内で行ったコミットの割合を求められます）。

```julia
cnt = LibGit2.with(LibGit2.GitRevWalker(repo)) do walker
    LibGit2.count((oid,repo)->(oid == commit_oid1), walker, oid=commit_oid1, by=LibGit2.Consts.SORT_TIME)
end
```

ここでは、`LibGit2.count` によって、特定の `GitHash` を持つコミットが、この走査対象にいくつあるかを調べます。`GitHash` はコミットごとに一意なので、`cnt` は `1` になります。
