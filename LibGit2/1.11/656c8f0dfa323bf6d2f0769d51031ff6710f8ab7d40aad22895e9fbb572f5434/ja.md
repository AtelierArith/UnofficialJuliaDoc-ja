```julia
LibGit2.rebase!(repo::GitRepo, upstream::AbstractString="", newbase::AbstractString="")
```

現在のブランチの自動マージリベースを試みます。`upstream`が提供されている場合はそれを使用し、そうでなければアップストリームトラッキングブランチから行います。`newbase`はリベースするブランチです。デフォルトでは、これは`upstream`です。

自動的に解決できない競合が発生した場合、リベースは中止され、リポジトリと作業ツリーは元の状態のままとなり、関数は`GitError`をスローします。これはおおよそ次のコマンドラインステートメントに相当します：

```julia
git rebase --merge [<upstream>]
if [ -d ".git/rebase-merge" ]; then
    git rebase --abort
fi
```
