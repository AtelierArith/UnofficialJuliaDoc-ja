```julia
merge!(repo::GitRepo, anns::Vector{GitAnnotated}; kwargs...) -> Bool
```

注釈付きコミット（[`GitAnnotated`](@ref) オブジェクトとしてキャプチャされた）`anns` からの変更をリポジトリ `repo` の HEAD にマージします。キーワード引数は次の通りです：

  * `merge_opts::MergeOptions = MergeOptions()`: マージを実行する方法に関するオプションで、ファストフォワードが許可されるかどうかを含みます。詳細については [`MergeOptions`](@ref) を参照してください。
  * `checkout_opts::CheckoutOptions = CheckoutOptions()`: チェックアウトを実行する方法に関するオプションです。詳細については [`CheckoutOptions`](@ref) を参照してください。

`anns` はリモートまたはローカルのブランチヘッドを指すことがあります。マージが成功した場合は `true` を返し、そうでない場合（例えば、ブランチに共通の祖先がないためにマージが不可能な場合）は `false` を返します。

# 例

```julia
upst_ann = LibGit2.GitAnnotated(repo, "branch/a")

# ブランチをマージする
LibGit2.merge!(repo, [upst_ann])
```
