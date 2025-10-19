```julia
LibGit2.map(f::Function, walker::GitRevWalker; oid::GitHash=GitHash(), range::AbstractString="", by::Cint=Consts.SORT_NONE, rev::Bool=false)
```

[`GitRevWalker`](@ref) `walker`を使用して、リポジトリの履歴内のすべてのコミットを「歩く」ために、各コミットに対して`f`を適用します。キーワード引数は次のとおりです。     * `oid`: 歩行を開始するコミットの[`GitHash`](@ref)。デフォルトは[`push_head!`](@ref)を使用し、したがってHEADコミットとそのすべての祖先を使用します。     * `range`: `GitHash`の範囲で、形式は`oid1..oid2`です。`f`はその2つの間のすべてのコミットに適用されます。     * `by`: ソート方法。デフォルトはソートしないことです。他のオプションは、トポロジーでソートすること（`LibGit2.Consts.SORT_TOPOLOGICAL`）、時間順にソートすること（`LibGit2.Consts.SORT_TIME`、最も古いものが最初）、または時間逆順にソートすること（`LibGit2.Consts.SORT_REVERSE`、最も最近のものが最初）です。     * `rev`: ソートされた順序を逆にするかどうか（たとえば、トポロジカルソートが使用されている場合）。

# 例

```julia
oids = LibGit2.with(LibGit2.GitRevWalker(repo)) do walker
    LibGit2.map((oid, repo)->string(oid), walker, by=LibGit2.Consts.SORT_TIME)
end
```

ここで、`LibGit2.map`は`GitRevWalker`を使用して各コミットを訪問し、その`GitHash`を見つけます。
