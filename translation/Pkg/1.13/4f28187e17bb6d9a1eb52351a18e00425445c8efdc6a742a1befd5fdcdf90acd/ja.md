```julia
Pkg.precompile(; strict::Bool=false, timing::Bool=false, workspace::Bool=false)
Pkg.precompile(pkg; strict::Bool=false, timing::Bool=false, workspace::Bool=false)
Pkg.precompile(pkgs; strict::Bool=false, timing::Bool=false, workspace::Bool=false)
Pkg.precompile(f, args...; kwargs...)
```

プロジェクトの依存関係をすべて、または指定したものだけ並列にプリコンパイルします。

各依存関係のプリコンパイルにかかった時間を表示するには、`timing=true`を設定します。

アクティブなプロジェクトだけでなく、ワークスペース内のすべてのプロジェクトをプリコンパイルするには、`workspace=true`を設定します。

複数のPkg操作による自動プリコンパイルを最後まで遅らせるには、次を使用します。環境をさまざまな方法で操作する場合、これが最も効率的なことがあります。

```julia
Pkg.precompile() do
    # Pkg actions here
end
```

!!! note
    指定したシステムでは、トップレベルの依存関係がマニフェスト内のすべての依存関係を読み込むとは限らないため、エラーが発生するのはトップレベルの依存関係をプリコンパイルするときだけです。キーワード引数`strict`に`true`を設定すると、すべての依存関係で発生したエラーをスローするように変更できます。


!!! note
    このメソッドは、マニフェストを変更するPkg操作の後に自動的に呼び出されます。以前のプリコンパイルでエラーになったパッケージは、変更されるまで自動モードで再試行されません。自動プリコンパイルを無効にするには、`ENV["JULIA_PKG_PRECOMPILE_AUTO"]=0`を設定します。使用するタスク数を手動で指定するには、`ENV["JULIA_NUM_PRECOMPILE_TASKS"]`を設定します。


!!! compat "Julia 1.8"
    プリコンパイルするパッケージを指定するには、Julia 1.8以降が必要です。


!!! compat "Julia 1.9"
    タイミングモードを使用するには、Julia 1.9以降が必要です。


!!! compat "Julia 1.13"
    `Pkg.precompile(f, args...; kwargs...)`のdoブロック構文を使用するには、Julia 1.13以降が必要です。


# Examples

```julia
Pkg.precompile()
Pkg.precompile("Foo")
Pkg.precompile(["Foo", "Bar"])
```
