```julia
clone(repo_url::AbstractString, repo_path::AbstractString; kwargs...)
```

`repo_url` にあるリモートリポジトリを、ローカルファイルシステム上の `repo_path` にクローンします。

キーワード引数は次のとおりです。

  * `branch::AbstractString=""`: リモートのどのブランチをクローンするかを指定します。指定しない場合は、リポジトリのデフォルトブランチ（通常は `master`）が使われます。
  * `isbare::Bool=false`: `true` の場合、リモートをベアリポジトリとしてクローンします。この場合、`repo_path` 自体が `repo_path/.git` ではなく Git ディレクトリになります。そのため、作業ツリーはチェックアウトできません。Git CLI の引数 `--bare` に相当します。
  * `remote_cb::Ptr{Cvoid}=C_NULL`: クローンの前にリモートを作成するために使うコールバックです。`C_NULL`（デフォルト）の場合、リモートの作成は試みず、すでに存在するものとして扱います。
  * `depth::Integer=0`: 指定したコミット数まで履歴を切り詰めたシャロークローンを作成します。`0` は完全なクローン（デフォルト）を指定します。シャロークローンから不足しているデータをすべて取得するには、`Consts.FETCH_DEPTH_UNSHALLOW` を使います。注: 執筆時点では、シャロークローンはネットワークプロトコル（http、https、git、ssh）でのみサポートされており、ローカルファイルシステムのパスではサポートされていません。（https://github.com/libgit2/libgit2/issues/6634)
  * `credentials::Creds=nothing`: プライベートリポジトリの認証に使う認証情報や設定を指定します。
  * `callbacks::Callbacks=Callbacks()`: ユーザーが指定するコールバックとペイロードです。

`git clone [-b <branch>] [--bare] [--depth <depth>] <repo_url> <repo_path>` と同等です。

# Examples

```julia
repo_url = "https://github.com/JuliaLang/Example.jl"
repo1 = LibGit2.clone(repo_url, "test_path")
repo2 = LibGit2.clone(repo_url, "test_path", isbare=true)
julia_url = "https://github.com/JuliaLang/julia"
julia_repo = LibGit2.clone(julia_url, "julia_path", branch="release-0.6")
# Shallow clone with only the most recent commit
shallow_repo = LibGit2.clone(repo_url, "shallow_path", depth=1)
```
