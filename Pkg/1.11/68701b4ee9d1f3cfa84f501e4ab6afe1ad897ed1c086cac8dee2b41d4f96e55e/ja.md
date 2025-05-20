```
Pkg.precompile(; strict::Bool=false, timing::Bool=false)
Pkg.precompile(pkg; strict::Bool=false, timing::Bool=false)
Pkg.precompile(pkgs; strict::Bool=false, timing::Bool=false)
```

プロジェクトのすべてまたは特定の依存関係を並行してプリコンパイルします。

`timing=true`を設定すると、各依存関係のプリコンパイルの所要時間が表示されます。

!!! note
    エラーは、トップレベルの依存関係をプリコンパイルする際にのみ発生します。これは、指定されたシステム上でトップレベルの依存関係によってすべてのマニフェスト依存関係が読み込まれない可能性があるためです。`strict`を`true`に設定することで、すべての依存関係でエラーを発生させることができます。


!!! note
    このメソッドは、マニフェストを変更する任意のPkgアクションの後に自動的に呼び出されます。以前にプリコンパイル中にエラーが発生したパッケージは、変更されるまで自動モードでは再試行されません。自動プリコンパイルを無効にするには、`ENV["JULIA_PKG_PRECOMPILE_AUTO"]=0`を設定します。使用するタスクの数を手動で制御するには、`ENV["JULIA_NUM_PRECOMPILE_TASKS"]`を設定します。


!!! compat "Julia 1.8"
    プリコンパイルするパッケージを指定するには、少なくともJulia 1.8が必要です。


!!! compat "Julia 1.9"
    タイミングモードには、少なくともJulia 1.9が必要です。


# 例

```julia
Pkg.precompile()
Pkg.precompile("Foo")
Pkg.precompile(["Foo", "Bar"])
```
