```
Pkg.test(; kwargs...)
Pkg.test(pkg::Union{String, Vector{String}; kwargs...)
Pkg.test(pkgs::Union{PackageSpec, Vector{PackageSpec}}; kwargs...)
```

**キーワード引数:**

  * `coverage::Union{Bool,String}=false`: テストされたパッケージのカバレッジ統計の生成を有効または無効にします。文字列が渡されると、それはテストプロセスの `--code-coverage` に直接渡されるため、例えば "user" はすべてのユーザーコードをテストします。
  * `allow_reresolve::Bool=true`: テスト環境でパッケージのバージョンを再解決することを許可します。
  * `julia_args::Union{Cmd, Vector{String}}`: テストプロセスに渡されるオプション。
  * `test_args::Union{Cmd, Vector{String}}`: テストプロセスで利用可能なテスト引数（`ARGS`）。

!!! compat "Julia 1.9"
    `allow_reresolve` は少なくとも Julia 1.9 が必要です。


!!! compat "Julia 1.9"
    `coverage` に文字列を渡すには少なくとも Julia 1.9 が必要です。


パッケージ `pkg` のテストを実行するか、`Pkg.test` に位置引数が与えられない場合は現在のプロジェクト（したがってパッケージである必要があります）のテストを実行します。パッケージはその `test/runtests.jl` ファイルを実行することでテストされます。

テストは、`pkg` パッケージとその（再帰的な）依存関係のみを含む一時的な環境を生成することによって実行されます。マニフェストファイルが存在し、`allow_reresolve` キーワード引数が `false` に設定されている場合、マニフェストファイルのバージョンが使用されます。そうでない場合は、実行可能なパッケージのセットが解決され、インストールされます。

テスト中は、プロジェクトファイルに次のように指定されたテスト特有の依存関係がアクティブになります。

```
[extras]
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[targets]
test = ["Test"]
```

テストは `check-bounds=yes` で新しいプロセスで実行され、デフォルトでは `startup-file=no` です。スタートアップファイル（`~/.julia/config/startup.jl`）を使用することが望ましい場合は、`--startup-file=yes` で Julia を起動します。テスト中の関数のインライン化は、`--inline=no` で Julia を起動することによって無効にできます（カバレッジの精度を向上させるため）。テストは、異なるコマンドライン引数が Julia に渡されたかのように実行できます。引数は `julia_args` キーワード引数に渡します。例えば、

```
Pkg.test("foo"; julia_args=["--inline"])
```

テスト自体で使用されるコマンドライン引数を渡すには、引数を `test_args` キーワード引数に渡します。これらはテストされるコードを制御したり、テストを何らかの方法で制御するために使用される可能性があります。例えば、テストにはオプションの追加テストがあるかもしれません：

```
if "--extended" in ARGS
    @test some_function()
end
```

これは次のようにテストすることで有効にできます。

```
Pkg.test("foo"; test_args=["--extended"])
```
