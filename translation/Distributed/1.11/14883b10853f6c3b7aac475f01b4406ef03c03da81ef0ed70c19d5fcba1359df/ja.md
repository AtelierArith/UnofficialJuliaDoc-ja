```julia
WorkerConfig
```

[`ClusterManager`](@ref)がクラスターに追加するワーカーを制御するために使用する型です。一部のフィールドは、すべてのクラスター管理ツールがホストにアクセスする際に使用します。

  * `io` – ワーカーへのアクセスに使用する接続（`IO`または`Nothing`のサブタイプ）
  * `host` – ホストアドレス（`String`または`Nothing`）
  * `port` – ワーカーへの接続に使用するホスト上のポート（`Int`または`Nothing`）

一部のフィールドは、初期化済みのホストにワーカーを追加する際にクラスター管理ツールが使用します。

  * `count` – ホスト上で起動するワーカーの数
  * `exename` – ホスト上のJulia実行ファイルへのパス。デフォルトは`"$(Sys.BINDIR)/julia"`または`"$(Sys.BINDIR)/julia-debug"`
  * `exeflags` – Juliaをリモートで起動する際に使用するフラグ

`userdata`フィールドは、外部管理ツールが各ワーカーの情報を格納するために使用します。

一部のフィールドは、`SSHManager`などの管理ツールが使用します。

  * `tunnel` – `true`（トンネリングを使用）、`false`（トンネリングを使用しない）、または[`nothing`](@ref)（管理ツールのデフォルト設定を使用）
  * `multiplex` – `true`（トンネリングにSSH多重化を使用）または`false`
  * `forward` – sshの`-L`オプションに使用する転送オプション
  * `bind_addr` – リモートホストでバインドするアドレス
  * `sshflags` – SSH接続の確立に使用するフラグ
  * `max_parallel` – ホスト上で並列接続するワーカーの最大数

一部のフィールドは、`LocalManager`と`SSHManager`の両方が使用します。

  * `connect_at` – ワーカー間接続か、ドライバーからワーカーへの接続かを判定するセットアップ呼び出し
  * `process` – 接続対象のプロセス（通常、管理ツールが[`addprocs`](@ref)中に割り当てます）
  * `ospid` – ホストOS上でのプロセスID。ワーカープロセスの割り込みに使用します
  * `environ` – Local/SSH管理ツールが一時情報を格納するためのプライベート辞書
  * `ident` – [`ClusterManager`](@ref)で識別されるワーカー
  * `connect_idents` – カスタムトポロジーを使用する場合に、ワーカーが接続する必要のあるワーカーIDのリスト
  * `enable_threaded_blas` – `true`、`false`、または`nothing`。ワーカーでスレッド化BLASを使用するかどうかを指定します
