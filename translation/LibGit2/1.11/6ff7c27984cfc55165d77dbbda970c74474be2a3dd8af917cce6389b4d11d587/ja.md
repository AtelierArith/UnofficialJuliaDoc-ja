```julia
lookup_branch(repo::GitRepo, branch_name::AbstractString, remote::Bool=false)::Union{GitReference, Nothing}
```

`branch_name`で指定されたブランチが、リポジトリ`repo`に存在するか確認してください。`remote`が`true`の場合、`repo`はリモートのGitリポジトリとみなします。それ以外の場合は、ローカルファイルシステムの一部です。

ブランチが存在する場合は、要求されたブランチへの`GitReference`を返し、存在しない場合は[`nothing`](@ref)を返してください。
