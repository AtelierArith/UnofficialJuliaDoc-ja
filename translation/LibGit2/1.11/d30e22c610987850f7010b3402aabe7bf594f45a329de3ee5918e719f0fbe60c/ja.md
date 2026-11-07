```julia
LibGit2.revcount(repo::GitRepo, commit1::AbstractString, commit2::AbstractString)
```

`commit1` と `commit2`（文字列形式のコミット識別子 OID）の間にあるリビジョン数を列挙します。`commit1` と `commit2` は異なるブランチにある可能性があるため、`revcount` は「左右」のリビジョン一覧（および件数）を実行し、左側と右側のコミット数をそれぞれ表す `Int` のタプルを返します。左側（または右側）のコミットとは、ツリーの対称差のどちら側からそのコミットに到達できるかを示します。

`git rev-list --left-right --count <commit1> <commit2>` と同等です。

# Examples

```julia
repo = LibGit2.GitRepo(repo_path)
repo_file = open(joinpath(repo_path, test_file), "a")
println(repo_file, "hello world")
flush(repo_file)
LibGit2.add!(repo, test_file)
commit_oid1 = LibGit2.commit(repo, "commit 1")
println(repo_file, "hello world again")
flush(repo_file)
LibGit2.add!(repo, test_file)
commit_oid2 = LibGit2.commit(repo, "commit 2")
LibGit2.revcount(repo, string(commit_oid1), string(commit_oid2))
```

これは `(-1, 0)` を返します。
