```
merge!(repo::GitRepo, anns::Vector{GitAnnotated}, fastforward::Bool; kwargs...) -> Bool
```

注釈付きコミット（[`GitAnnotated`](@ref) オブジェクトとしてキャプチャされた）`anns` からリポジトリ `repo` の HEAD に変更をマージします。`fastforward` が `true` の場合、*のみ* ファストフォワードマージが許可されます。この場合、競合が発生した場合、マージは失敗します。それ以外の場合、`fastforward` が `false` の場合、マージはユーザーが解決する必要のある競合ファイルを生成する可能性があります。

キーワード引数は次のとおりです：

  * `merge_opts::MergeOptions = MergeOptions()`: マージを実行する方法に関するオプション、ファストフォワードが許可されているかどうかを含みます。詳細については [`MergeOptions`](@ref) を参照してください。
  * `checkout_opts::CheckoutOptions = CheckoutOptions()`: チェックアウトを実行する方法に関するオプション。詳細については [`CheckoutOptions`](@ref) を参照してください。

`anns` はリモートまたはローカルのブランチヘッドを指すことがあります。マージが成功した場合は `true` を返し、そうでない場合は `false` を返します（たとえば、ブランチに共通の祖先がないためにマージが不可能な場合など）。

# 例

```julia
upst_ann_1 = LibGit2.GitAnnotated(repo, "branch/a")

# ブランチをマージし、ファストフォワード
LibGit2.merge!(repo, [upst_ann_1], true)

# マージ競合！
upst_ann_2 = LibGit2.GitAnnotated(repo, "branch/b")
# ブランチをマージし、ファストフォワードを試みる
LibGit2.merge!(repo, [upst_ann_2], true) # false を返します
LibGit2.merge!(repo, [upst_ann_2], false) # true を返します
```
