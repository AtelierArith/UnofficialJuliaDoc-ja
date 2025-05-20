```
lookup_branch(repo::GitRepo, branch_name::AbstractString, remote::Bool=false) -> Union{GitReference, Nothing}
```

`branch_name`で指定されたブランチがリポジトリ`repo`に存在するかどうかを判断します。`remote`が`true`の場合、`repo`はリモートgitリポジトリであると見なされます。それ以外の場合は、ローカルファイルシステムの一部です。

存在する場合は要求されたブランチへの`GitReference`を返し、存在しない場合は[`nothing`](@ref)を返します。
