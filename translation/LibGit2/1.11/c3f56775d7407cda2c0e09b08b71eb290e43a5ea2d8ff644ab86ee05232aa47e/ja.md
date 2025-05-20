```
LibGit2.revcount(repo::GitRepo, commit1::AbstractString, commit2::AbstractString)
```

`commit1` と `commit2` の間のリビジョンの数をリストします（コミットの OID を文字列形式で）。`commit1` と `commit2` は異なるブランチにある可能性があるため、`revcount` は「左-右」リビジョンリスト（およびカウント）を実行し、左と右のコミットの数をそれぞれ表す `Int` のタプルを返します。左（または右）コミットは、ツリーの対称差のどちら側からコミットに到達できるかを指します。

`git rev-list --left-right --count <commit1> <commit2>` と同等です。

# 例

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
