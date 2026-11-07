```julia
GitRevWalker(repo::GitRepo)
```

`GitRevWalker` は、Git リポジトリ `repo` の *リビジョン*（つまりコミット）を順にたどります。これはリポジトリ内のコミットを集めたもので、反復処理に対応し、[`LibGit2.map`](@ref) および [`LibGit2.count`](@ref) を呼び出せます（たとえば、`LibGit2.count` を使って、特定の作者がリポジトリ内で作成したコミットの割合を求められます）。

```julia
cnt = LibGit2.with(LibGit2.GitRevWalker(repo)) do walker
    LibGit2.count((oid,repo)->(oid == commit_oid1), walker, oid=commit_oid1, by=LibGit2.Consts.SORT_TIME)
end
```

ここでは、`LibGit2.count` によって、指定した `GitHash` を持つ、ウォーク上のコミット数を求めます。`GitHash` はコミットごとに一意なので、`cnt` は `1` になります。
