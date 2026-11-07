```julia
LibGit2.map(f::Function, walker::GitRevWalker; oid::GitHash=GitHash(), range::AbstractString="", by::Cint=Consts.SORT_NONE, rev::Bool=false)
```

[`GitRevWalker`](@ref) `walker`を使ってリポジトリの履歴にあるすべてのコミットを「たどり」、その過程で各コミットに対して`f`を適用します。キーワード引数は次のとおりです。     * `oid`: たどり始めるコミットの[`GitHash`](@ref)。デフォルトでは       [`push_head!`](@ref)を使うため、HEADコミットとそのすべての祖先が対象になります。     * `range`: `GitHash`の範囲。形式は`oid1..oid2`です。`f`は       その2つの間にあるすべてのコミットに適用されます。     * `by`: 並べ替え方法。デフォルトでは並べ替えません。ほかに、トポロジー順（`LibGit2.Consts.SORT_TOPOLOGICAL`）、時系列の昇順       （`LibGit2.Consts.SORT_TIME`、最も古いものが先）、時系列の降順       （`LibGit2.Consts.SORT_REVERSE`、最も新しいものが先）で並べ替える方法があります。     * `rev`: 並べ替えた順序を逆にするかどうか（たとえば、トポロジー順で並べ替える場合）。

# Examples

```julia
oids = LibGit2.with(LibGit2.GitRevWalker(repo)) do walker
    LibGit2.map((oid, repo)->string(oid), walker, by=LibGit2.Consts.SORT_TIME)
end
```

ここでは、`LibGit2.map`は`GitRevWalker`を使って各コミットを調べ、その`GitHash`を見つけます。
