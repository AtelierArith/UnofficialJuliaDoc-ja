```julia
addprocs(np::Integer=Sys.CPU_THREADS; restrict=true, kwargs...) -> List of process identifiers
```

組み込みの`LocalManager`を使って、ローカルホスト上で`np`個のワーカーを起動します。

ローカルワーカーは、メインプロセスの現在のパッケージ環境（アクティブなプロジェクト、[`LOAD_PATH`](@ref)、[`DEPOT_PATH`](@ref)）を引き継ぎます。

!!! warning
    ワーカーは`~/.julia/config/startup.jl`起動スクリプトを実行せず、他の実行中プロセスとグローバル状態（コマンドラインスイッチ、グローバル変数、新しいメソッド定義、読み込み済みモジュールなど）を同期しないことに注意してください。


**キーワード引数**:

  * `restrict::Bool`: `true`（デフォルト）のバインディングを`127.0.0.1`に制限する場合に指定します。
  * `dir`、`exename`、`exeflags`、`env`、`topology`、`lazy`、`enable_threaded_blas`: `SSHManager`と同じ効果があります。[`addprocs(machines::AbstractVector)`](@ref)のドキュメントを参照してください。

!!! compat "Julia 1.9"
    パッケージ環境の継承と`env`キーワード引数は、Julia 1.9で追加されました。

