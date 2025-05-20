```
commit(repo::GitRepo, msg::AbstractString; kwargs...) -> GitHash
```

[`git_commit_create`](https://libgit2.org/libgit2/#HEAD/group/commit/git_commit_create) のラッパー。リポジトリ `repo` にコミットを作成します。`msg` はコミットメッセージです。新しいコミットのOIDを返します。

キーワード引数は次の通りです：

  * `refname::AbstractString=Consts.HEAD_FILE`：NULLでない場合、新しいコミットを指すように更新するリファレンスの名前。例えば、`"HEAD"` は現在のブランチのHEADを更新します。リファレンスがまだ存在しない場合は、作成されます。
  * `author::Signature = Signature(repo)` は、コミットを作成した人に関する情報を含む `Signature` です。
  * `committer::Signature = Signature(repo)` は、リポジトリにコミットを行った人に関する情報を含む `Signature` です。必ずしも `author` と同じではなく、例えば `author` がパッチを `committer` にメールで送信し、`committer` がそれをコミットした場合などです。
  * `tree_id::GitHash = GitHash()` は、コミットを作成するために使用するgitツリーで、その系譜と他の履歴との関係を示します。`tree` は `repo` に属している必要があります。
  * `parent_ids::Vector{GitHash}=GitHash[]` は、新しいコミットの親コミットとして使用する [`GitHash`](@ref) のコミットのリストで、空であっても構いません。コミットは、例えばマージコミットの場合、複数の親を持つことがあります。
