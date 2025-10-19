```julia
merge!(repo::GitRepo; kwargs...) -> Bool
```

リポジトリ `repo` で git マージを実行し、分岐した履歴を持つコミットを現在のブランチにマージします。マージが成功した場合は `true` を返し、そうでない場合は `false` を返します。

キーワード引数は次の通りです：

  * `committish::AbstractString=""`: `committish` に指定されたコミットをマージします。
  * `branch::AbstractString=""`: `branch` ブランチと、そのブランチが現在のブランチから分岐して以来のすべてのコミットをマージします。
  * `fastforward::Bool=false`: `fastforward` が `true` の場合、マージがファストフォワードである場合のみマージを行います（現在のブランチのヘッドがマージされるコミットの祖先である場合）。そうでない場合はマージを拒否し、`false` を返します。これは git CLI オプション `--ff-only` と同等です。
  * `merge_opts::MergeOptions=MergeOptions()`: `merge_opts` は、競合が発生した場合のマージ戦略など、マージのオプションを指定します。
  * `checkout_opts::CheckoutOptions=CheckoutOptions()`: `checkout_opts` は、チェックアウトステップのオプションを指定します。

`git merge [--ff-only] [<committish> | <branch>]` と同等です。

!!! note
    `branch` を指定する場合、これは参照形式で行う必要があります。文字列は `GitReference` に変換されるためです。たとえば、`branch_a` ブランチをマージしたい場合は、`merge!(repo, branch="refs/heads/branch_a")` と呼び出します。

