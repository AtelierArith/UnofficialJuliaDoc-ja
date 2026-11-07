```julia
commit(repo::GitRepo, msg::AbstractString; kwargs...)::GitHash
```

[`git_commit_create`](https://libgit2.org/libgit2/#HEAD/group/commit/git_commit_create)をラップします。リポジトリ`repo`にコミットを作成します。`msg`はコミットメッセージです。新しいコミットのOIDを返します。

キーワード引数は次のとおりです。

  * `refname::AbstractString=Consts.HEAD_FILE`: NULLでない場合、新しいコミットを指すように更新する参照名です。たとえば、`"HEAD"`を指定すると、現在のブランチのHEADが更新されます。参照がまだ存在しない場合は作成されます。
  * `author::Signature = Signature(repo)`は、コミットの作成者に関する情報を含む`Signature`です。
  * `committer::Signature = Signature(repo)`は、リポジトリにコミットを記録した人に関する情報を含む`Signature`です。`author`と同一とは限りません。たとえば、`author`がパッチをメールで`committer`に送り、その人がコミットした場合などです。
  * `tree_id::GitHash = GitHash()`は、コミットの作成に使用するgitツリーです。系譜と、ほかの履歴との関係を示します。`tree`は`repo`に属している必要があります。
  * `parent_ids::Vector{GitHash}=GitHash[]`は、新しいコミットの親コミットとして使用する、[`GitHash`](@ref)によるコミットのリストです。空でもかまいません。たとえば、マージコミットのように、コミットが複数の親を持つ場合があります。
