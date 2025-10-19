```julia
WorkerConfig
```

[`ClusterManager`](@ref)によって使用されるタイプで、クラスターに追加されたワーカーを制御します。いくつかのフィールドは、すべてのクラスター管理者によってホストにアクセスするために使用されます：

  * `io` – ワーカーにアクセスするために使用される接続（`IO`のサブタイプまたは`Nothing`）
  * `host` – ホストアドレス（`String`または`Nothing`）
  * `port` – ワーカーに接続するためにホスト上で使用されるポート（`Int`または`Nothing`）

いくつかは、クラスター管理者がすでに初期化されたホストにワーカーを追加するために使用されます：

  * `count` – ホスト上で起動するワーカーの数
  * `exename` – ホスト上のJulia実行可能ファイルへのパス、デフォルトは`"$(Sys.BINDIR)/julia"`または`"$(Sys.BINDIR)/julia-debug"`
  * `exeflags` – Juliaをリモートで起動する際に使用するフラグ

`userdata`フィールドは、外部管理者によって各ワーカーの情報を保存するために使用されます。

いくつかのフィールドは`SSHManager`や類似の管理者によって使用されます：

  * `tunnel` – `true`（トンネリングを使用）、`false`（トンネリングを使用しない）、または[`nothing`](@ref)（管理者のデフォルトを使用）
  * `multiplex` – `true`（トンネリングのためにSSHマルチプレクシングを使用）または`false`
  * `forward` – sshの`-L`オプションに使用される転送オプション
  * `bind_addr` – リモートホストでバインドするアドレス
  * `sshflags` – SSH接続を確立する際に使用するフラグ
  * `max_parallel` – ホスト上で並行して接続する最大ワーカー数

いくつかのフィールドは`LocalManager`と`SSHManager`の両方によって使用されます：

  * `connect_at` – これはワーカー間の接続かドライバーからワーカーへのセットアップコールかを決定します
  * `process` – 接続されるプロセス（通常、管理者は[`addprocs`](@ref)中にこれを割り当てます）
  * `ospid` – ホストOSに従ったプロセスID、ワーカープロセスを中断するために使用
  * `environ` – Local/SSH管理者によって一時的な情報を保存するために使用されるプライベート辞書
  * `ident` – [`ClusterManager`](@ref)によって識別されたワーカー
  * `connect_idents` – カスタムトポロジーを使用する場合にワーカーが接続しなければならないワーカーIDのリスト
  * `enable_threaded_blas` – `true`、`false`、または`nothing`、ワーカーでスレッド化されたBLASを使用するかどうか
