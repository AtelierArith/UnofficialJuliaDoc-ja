```julia
Pkg.test(; kwargs...)
Pkg.test(pkg::Union{String, Vector{String}; kwargs...)
Pkg.test(pkgs::Union{PackageSpec, Vector{PackageSpec}}; kwargs...)
```

**キーワード引数:**

  * `coverage::Union{Bool,String}=false`: テスト対象のパッケージについて、カバレッジ統計の生成を有効または無効にします。文字列を渡すと、テストプロセスの `--code-coverage` にそのまま渡されます。たとえば "user" を指定すると、すべてのユーザーコードがテスト対象になります。
  * `allow_reresolve::Bool=true`: テスト環境でパッケージのバージョンを再解決することを Pkg に許可します。
  * `julia_args::Union{Cmd, Vector{String}}`: テストプロセスに渡すオプションです。
  * `test_args::Union{Cmd, Vector{String}}`: テストプロセスで利用できるテスト引数（`ARGS`）です。

!!! compat "Julia 1.9"
    `allow_reresolve` には Julia 1.9 以降が必要です。


!!! compat "Julia 1.9"
    `coverage` に文字列を渡すには、Julia 1.9 以降が必要です。


指定したパッケージのテストを実行します。`Pkg.test` に位置引数を指定しなかった場合は、現在のプロジェクトのテストを実行します（現在のプロジェクトはパッケージである必要があります）。パッケージのテストは、その `test/runtests.jl` ファイルを実行することで行われます。

テストは、パッケージのテスト専用の依存関係も含む一時環境で実行されます。現在のプロジェクトの依存関係のバージョンと、テスト専用の依存関係との間に互換性の衝突がない限り、テスト環境では現在のプロジェクトの依存関係のバージョンが使用されます。衝突がある場合、`allow_reresolve` が `false` ならエラーが送出され、`allow_reresolve` が `true` なら、条件を満たす依存関係のバージョンの組み合わせを解決し、それを使用します。

テスト専用の依存関係は、プロジェクトファイルで次のように宣言します。

```toml
[extras]
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[targets]
test = ["Test"]
```

テストは新しいプロセスで実行されます。このプロセスの `check-bounds` の設定は現在の Julia セッションと同じで、デフォルトでは `startup-file=no` が指定されます。スタートアップファイル（`~/.julia/config/startup.jl`）を使用したい場合は、`--startup-file=yes` を指定して Julia を起動してください。

`--inline=no` を指定して Julia を起動すると、テスト中の関数のインライン化を無効にできます（カバレッジの精度が向上します）。Julia に別のコマンドライン引数を渡した場合と同じ条件でテストを実行するには、その引数を `julia_args` キーワード引数に渡します。例:

```julia
Pkg.test("foo"; julia_args=["--inline"])
```

テスト自体で使用するコマンドライン引数を渡すには、`test_args` キーワード引数に指定します。これらの引数は、テスト対象のコードを制御したり、テストの動作を制御したりするために使用できます。たとえば、必要に応じて実行する追加のテストを次のように用意できます。

```julia
if "--extended" in ARGS
    @test some_function()
end
```

この追加テストは、次のようにテストを実行すると有効になります。

```julia
Pkg.test("foo"; test_args=["--extended"])
```
