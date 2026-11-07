```julia
GitBlame(repo::GitRepo, path::AbstractString; options::BlameOptions=BlameOptions())
```

`repo` の履歴から得られる変更情報を使って、`path` ファイルの `GitBlame` オブジェクトを構築します。`GitBlame` オブジェクトには、誰が、いつ、どのようにファイルのどの部分を変更したかが記録されます。`options` は、ファイルの内容をどのように分割するか、および調査するコミットを制御します。詳しくは [`BlameOptions`](@ref) を参照してください。
