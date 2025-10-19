```julia
addprocs(np::Integer=Sys.CPU_THREADS; restrict=true, kwargs...) -> プロセス識別子のリスト
```

ローカルホストで `np` ワーカーを起動し、内蔵の `LocalManager` を使用します。

ローカルワーカーは、メインプロセスから現在のパッケージ環境（すなわち、アクティブプロジェクト、[`LOAD_PATH`](@ref)、および [`DEPOT_PATH`](@ref)）を継承します。

!!! warning
    ワーカーは `~/.julia/config/startup.jl` スタートアップスクリプトを実行せず、他の実行中のプロセスとグローバル状態（コマンドラインスイッチ、グローバル変数、新しいメソッド定義、読み込まれたモジュールなど）を同期しないことに注意してください。


**キーワード引数**:

  * `restrict::Bool`: `true`（デフォルト）の場合、バインディングは `127.0.0.1` に制限されます。
  * `dir`, `exename`, `exeflags`, `env`, `topology`, `lazy`, `enable_threaded_blas`: `SSHManager` と同じ効果があります。 [`addprocs(machines::AbstractVector)`](@ref) のドキュメントを参照してください。

!!! compat "Julia 1.9"
    パッケージ環境の継承と `env` キーワード引数は、Julia 1.9 で追加されました。

