```julia
GitBlame(repo::GitRepo, path::AbstractString; options::BlameOptions=BlameOptions())
```

`path`にあるファイルのための`GitBlame`オブジェクトを構築し、`repo`の履歴から得られた変更情報を使用します。`GitBlame`オブジェクトは、誰がファイルのどの部分をいつ、どのように変更したかを記録します。`options`は、ファイルの内容をどのように分離し、どのコミットを調査するかを制御します - 詳細については[`BlameOptions`](@ref)を参照してください。
