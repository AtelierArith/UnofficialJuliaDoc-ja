```
clone(repo_url::AbstractString, repo_path::AbstractString; kwargs...)
```

リモートリポジトリを `repo_url` からローカルファイルシステムの場所 `repo_path` にクローンします。

キーワード引数は次の通りです：

  * `branch::AbstractString=""`: デフォルトのリポジトリブランチ（通常は `master`）でない場合、クローンするリモートのブランチ。
  * `isbare::Bool=false`: `true` の場合、リモートをベアリポジトリとしてクローンし、`repo_path` 自体が git ディレクトリとなり、`repo_path/.git` ではなくなります。これにより、作業ツリーをチェックアウトすることはできません。git CLI 引数 `--bare` の役割を果たします。
  * `remote_cb::Ptr{Cvoid}=C_NULL`: クローンする前にリモートを作成するために使用されるコールバック。`C_NULL`（デフォルト）の場合、リモートを作成しようとはせず、すでに存在していると見なされます。
  * `credentials::Creds=nothing`: プライベートリポジトリに対して認証する際に、資格情報や設定を提供します。
  * `callbacks::Callbacks=Callbacks()`: ユーザー提供のコールバックとペイロード。

`git clone [-b <branch>] [--bare] <repo_url> <repo_path>` と同等です。

# 例

```julia
repo_url = "https://github.com/JuliaLang/Example.jl"
repo1 = LibGit2.clone(repo_url, "test_path")
repo2 = LibGit2.clone(repo_url, "test_path", isbare=true)
julia_url = "https://github.com/JuliaLang/julia"
julia_repo = LibGit2.clone(julia_url, "julia_path", branch="release-0.6")
```
