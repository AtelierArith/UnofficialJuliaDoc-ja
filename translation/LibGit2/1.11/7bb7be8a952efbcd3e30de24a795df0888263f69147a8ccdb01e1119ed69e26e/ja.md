```julia
GitRevWalker(repo::GitRepo)
```

`GitRevWalker`は、gitリポジトリ`repo`の*リビジョン*（すなわちコミット）を*歩く*ものです。これはリポジトリ内のコミットのコレクションであり、反復処理や[`LibGit2.map`](@ref)および[`LibGit2.count`](@ref)への呼び出しをサポートします（たとえば、`LibGit2.count`は、リポジトリ内のコミットのうち、特定の著者によって行われたコミットの割合を決定するために使用できます）。

```julia
cnt = LibGit2.with(LibGit2.GitRevWalker(repo)) do walker
    LibGit2.count((oid,repo)->(oid == commit_oid1), walker, oid=commit_oid1, by=LibGit2.Consts.SORT_TIME)
end
```

ここで、`LibGit2.count`は、特定の`GitHash`を持つコミットの数を歩きながら見つけます。`GitHash`はコミットに固有であるため、`cnt`は`1`になります。
