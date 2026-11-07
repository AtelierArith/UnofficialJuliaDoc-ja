```julia
merge!(repo::GitRepo, anns::Vector{GitAnnotated}; kwargs...)::Bool
```

注釈付きコミット（[`GitAnnotated`](@ref) オブジェクトとして取得）`anns` の変更を、リポジトリ `repo` の HEAD にマージします。キーワード引数は次のとおりです。

  * `merge_opts::MergeOptions = MergeOptions()`: 高速フォワードを許可するかどうかなど、マージ方法を指定するオプションです。詳しくは [`MergeOptions`](@ref) を参照してください。
  * `checkout_opts::CheckoutOptions = CheckoutOptions()`: チェックアウト方法を指定するオプションです。詳しくは [`CheckoutOptions`](@ref) を参照してください。

`anns` には、リモートまたはローカルのブランチヘッドを指定できます。マージに成功した場合は `true` を返し、成功しなかった場合は `false` を返します（たとえば、ブランチに共通の祖先がなく、マージできない場合）。

# Examples

```julia
upst_ann = LibGit2.GitAnnotated(repo, "branch/a")

# merge the branch in
LibGit2.merge!(repo, [upst_ann])
```
