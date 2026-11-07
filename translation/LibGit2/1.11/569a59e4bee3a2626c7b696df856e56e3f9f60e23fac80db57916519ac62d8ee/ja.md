```julia
merge!(repo::GitRepo, anns::Vector{GitAnnotated}, fastforward::Bool; kwargs...)::Bool
```

注釈付きコミット（[`GitAnnotated`](@ref) オブジェクトとして取得）`anns` の変更を、リポジトリ `repo` の HEAD にマージします。`fastforward` が `true` の場合、許可されるのはファストフォワードマージのみです。この場合、競合が発生するとマージは失敗します。それ以外の場合、`fastforward` が `false` であれば、競合ファイルが生成されることがあり、その場合はユーザーが解決する必要があります。

キーワード引数は次のとおりです。

  * `merge_opts::MergeOptions = MergeOptions()`: ファストフォワードを許可するかどうかなど、マージ方法を指定するオプションです。詳しくは [`MergeOptions`](@ref) を参照してください。
  * `checkout_opts::CheckoutOptions = CheckoutOptions()`: チェックアウト方法を指定するオプションです。詳しくは [`CheckoutOptions`](@ref) を参照してください。

`anns` は、リモートまたはローカルのブランチヘッドを指す場合があります。マージに成功した場合は `true` を返し、成功しなかった場合（たとえば、ブランチに共通の祖先がなく、マージできない場合）は `false` を返します。

# Examples

```julia
upst_ann_1 = LibGit2.GitAnnotated(repo, "branch/a")

# merge the branch in, fastforward
LibGit2.merge!(repo, [upst_ann_1], true)

# merge conflicts!
upst_ann_2 = LibGit2.GitAnnotated(repo, "branch/b")
# merge the branch in, try to fastforward
LibGit2.merge!(repo, [upst_ann_2], true) # will return false
LibGit2.merge!(repo, [upst_ann_2], false) # will return true
```
