```julia
LibGit2.count(f::Function, walker::GitRevWalker; oid::GitHash=GitHash(), by::Cint=Consts.SORT_NONE, rev::Bool=false)
```

[`GitRevWalker`](@ref) `walker`を使って、リポジトリの履歴にあるすべてのコミットを「たどり」、`f`を適用したときに`true`を返すコミットの数を調べます。キーワード引数は次のとおりです。     * `oid`: たどり始めるコミットの[`GitHash`](@ref)。デフォルトでは[`push_head!`](@ref)を使うため、HEADコミットとそのすべての祖先が対象になります。     * `by`: ソート方法。デフォルトではソートしません。ほかに、トポロジー順（`LibGit2.Consts.SORT_TOPOLOGICAL`）、時間順の昇順（`LibGit2.Consts.SORT_TIME`、最も古いものが先）、時間順の降順（`LibGit2.Consts.SORT_REVERSE`、最も新しいものが先）でソートできます。     * `rev`: ソート順を逆にするかどうか（たとえば、トポロジー順でソートする場合）。

# Examples

```julia
cnt = LibGit2.with(LibGit2.GitRevWalker(repo)) do walker
    LibGit2.count((oid, repo)->(oid == commit_oid1), walker, oid=commit_oid1, by=LibGit2.Consts.SORT_TIME)
end
```

`LibGit2.count`は、特定の`GitHash` `commit_oid1`を持つコミットのうち、そのコミットからたどり始め、時間を進めていったときに見つかるものの数を調べます。`GitHash`はコミットごとに一意であるため、`cnt`は`1`になります。
