```julia
Pkg.test(; kwargs...)
Pkg.test(pkg::Union{String, Vector{String}; kwargs...)
Pkg.test(pkgs::Union{PackageSpec, Vector{PackageSpec}}; kwargs...)
```

**キーワード引数:**

  * `coverage::Union{Bool,String}=false`: テスト対象パッケージのカバレッジ統計の生成を有効または無効にします。文字列を渡すと、テストプロセス内の `--code-coverage` にそのまま渡されます。たとえば、"user" を指定すると、すべてのユーザーコードがテスト対象になります。
  * `allow_reresolve::Bool=true`: Pkg がテスト環境内のパッケージのバージョンを再解決することを許可します。
  * `julia_args::Union{Cmd, Vector{String}}`: テストプロセスに渡すオプションです。
  * `test_args::Union{Cmd, Vector{String}}`: テストプロセス内で利用できるテスト引数（`ARGS`）です。

!!! compat "Julia 1.9"
    `allow_reresolve` には Julia 1.9 以降が必要です。


!!! compat "Julia 1.9"
    `coverage` に文字列を渡すには、Julia 1.9 以降が必要です。


指定したパッケージのテストを実行します。`Pkg.test` に位置引数を指定しない場合は、現在のプロジェクトのテストを実行します（現在のプロジェクトはパッケージである必要があります）。パッケージのテストは、その `test/runtests.jl` ファイルを実行することで行われます。

テストは、パッケージのテスト専用の依存関係も含む一時環境で実行されます。依存関係のバージョンとテスト専用の依存関係との間に互換性の競合がない限り、テスト環境では現在のプロジェクトの依存関係のバージョンが使用されます。競合がある場合、`allow_reresolve` が `false` であればエラーがスローされ、`allow_reresolve` が `true` であれば、条件を満たす依存関係のバージョンの組み合わせが解決され、使用されます。

テスト専用の依存関係は、プロジェクトファイルで次のように宣言します。

```toml
[extras]
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[targets]
test = ["Test"]
```

テストは、現在の Julia セッションと同じ `check-bounds` 設定を持つ新しいプロセスで実行され、デフォルトでは `startup-file=no` が指定されます。起動ファイル（`~/.julia/config/startup.jl`）を使用するには、`--startup-file=yes` を指定して julia を起動してください。

`--inline=no` を指定して julia を起動すると、テスト中の関数のインライン化を無効にできます（カバレッジの精度が向上します）。julia に異なるコマンドライン引数を渡した場合と同じ条件でテストを実行するには、それらの引数を代わりに `julia_args` キーワード引数に渡します。例:

```julia
Pkg.test("foo"; julia_args=["--inline"])
```

テスト自体で使用するコマンドライン引数を渡すには、`test_args` キーワード引数に指定します。これらの引数は、テスト対象のコードを制御したり、何らかの形でテストを制御したりするために使用できます。たとえば、任意で実行できる追加のテストを次のように用意できます。

```julia
if "--extended" in ARGS
    @test some_function()
end
```

この追加テストは、次のようにテストを実行することで有効にできます。

```julia
Pkg.test("foo"; test_args=["--extended"])
```
