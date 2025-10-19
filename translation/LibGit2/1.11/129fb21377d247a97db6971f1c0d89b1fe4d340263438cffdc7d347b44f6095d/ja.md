```julia
GitAnnotated(repo::GitRepo, commit_id::GitHash)
GitAnnotated(repo::GitRepo, ref::GitReference)
GitAnnotated(repo::GitRepo, fh::FetchHead)
GitAnnotated(repo::GitRepo, committish::AbstractString)
```

注釈付きのgitコミットは、どのように検索され、なぜそのように検索されたのかに関する情報を持っているため、リベースやマージ操作はコミットのコンテキストに関するより多くの情報を持つことができます。たとえば、コンフリクトファイルには、マージで衝突しているソース/ターゲットブランチに関する情報が含まれています。注釈付きコミットは、たとえば[`FetchHead`](@ref)が渡されたときのリモートブランチの先端や、`GitReference`を使用して記述されたブランチの先頭を参照することができます。
