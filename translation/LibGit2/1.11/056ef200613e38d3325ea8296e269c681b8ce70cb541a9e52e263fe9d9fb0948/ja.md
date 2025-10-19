```julia
LibGit2.count(f::Function, walker::GitRevWalker; oid::GitHash=GitHash(), by::Cint=Consts.SORT_NONE, rev::Bool=false)
```

[`GitRevWalker`](@ref) `walker`を使用して、リポジトリの履歴内のすべてのコミットを「歩く」ことで、`f`が適用されたときに`true`を返すコミットの数を見つけます。キーワード引数は次のとおりです。     * `oid`: 歩行を開始するコミットの[`GitHash`](@ref)。デフォルトは[`push_head!`](@ref)を使用し、したがってHEADコミットとそのすべての祖先を使用します。     * `by`: ソート方法。デフォルトはソートしないことです。他のオプションは、トポロジーによるソート（`LibGit2.Consts.SORT_TOPOLOGICAL`）、時間順にソート（`LibGit2.Consts.SORT_TIME`、最も古いものが最初）または時間逆順にソート（`LibGit2.Consts.SORT_REVERSE`、最も最近のものが最初）です。     * `rev`: ソートされた順序を逆にするかどうか（たとえば、トポロジカルソートが使用されている場合）。

# 例

```julia
cnt = LibGit2.with(LibGit2.GitRevWalker(repo)) do walker
    LibGit2.count((oid, repo)->(oid == commit_oid1), walker, oid=commit_oid1, by=LibGit2.Consts.SORT_TIME)
end
```

`LibGit2.count`は、特定の`GitHash` `commit_oid1`を持つコミットに沿った歩行の中でコミットの数を見つけ、そのコミットから歩行を開始し、そこから時間順に進みます。`GitHash`はコミットに固有であるため、`cnt`は`1`になります。
