```julia
merge!(repo::GitRepo; kwargs...)::Bool
```

リポジトリ `repo` で git merge を実行し、履歴が分岐したコミットを現在のブランチにマージします。マージに成功した場合は `true`、失敗した場合は `false` を返します。

キーワード引数は次のとおりです。

  * `committish::AbstractString=""`: `committish` にある指定したコミットをマージします。
  * `branch::AbstractString=""`: ブランチ `branch` と、現在のブランチから分岐して以降のすべてのコミットをマージします。
  * `fastforward::Bool=false`: `fastforward` が `true` の場合、マージが早送り（現在のブランチの HEAD がマージ対象のコミットの祖先である状態）になる場合に限ってマージします。それ以外の場合はマージを拒否し、`false` を返します。これは git CLI のオプション `--ff-only` と同等です。
  * `merge_opts::MergeOptions=MergeOptions()`: `merge_opts` には、競合時のマージ戦略など、マージに関するオプションを指定します。
  * `checkout_opts::CheckoutOptions=CheckoutOptions()`: `checkout_opts` には、チェックアウト手順に関するオプションを指定します。

`git merge [--ff-only] [<committish> | <branch>]` と同等です。

!!! note
    `branch` を指定する場合は、参照形式で指定する必要があります。文字列が `GitReference` に変換されるためです。たとえば、ブランチ `branch_a` をマージする場合は、`merge!(repo, branch="refs/heads/branch_a")` を呼び出します。

