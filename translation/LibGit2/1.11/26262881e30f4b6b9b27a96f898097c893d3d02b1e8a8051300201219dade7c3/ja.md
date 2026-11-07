```julia
GitAnnotated(repo::GitRepo, commit_id::GitHash)
GitAnnotated(repo::GitRepo, ref::GitReference)
GitAnnotated(repo::GitRepo, fh::FetchHead)
GitAnnotated(repo::GitRepo, committish::AbstractString)
```

注釈付きの git コミットには、そのコミットがどのように検索され、なぜ選ばれたのかという情報が含まれます。そのため、rebase や merge の操作で、コミットのコンテキストをより詳しく把握できます。たとえば、競合しているマージのソースブランチとターゲットブランチに関する情報が、競合ファイルに含まれます。注釈付きコミットは、たとえば [`FetchHead`](@ref) が渡された場合のリモートブランチの先端や、`GitReference` を使って記述されたブランチヘッドを参照できます。
