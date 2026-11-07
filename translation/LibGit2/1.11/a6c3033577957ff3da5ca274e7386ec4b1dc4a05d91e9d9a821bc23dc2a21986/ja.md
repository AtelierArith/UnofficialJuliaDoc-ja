```julia
LibGit2.rebase!(repo::GitRepo, upstream::AbstractString="", newbase::AbstractString="")
```

現在のブランチを、`upstream` が指定されていればそこから、指定されていなければ上流の追跡ブランチから、自動マージリベースします。リベース先のブランチは `newbase` です。デフォルトでは `upstream` です。

自動解決できない競合が発生した場合、リベースは中止され、リポジトリと作業ツリーは元の状態のままになります。また、この関数は `GitError` をスローします。これは、おおむね次のコマンドライン文に相当します。

```julia
git rebase --merge [<upstream>]
if [ -d ".git/rebase-merge" ]; then
    git rebase --abort
fi
```
