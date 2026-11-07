```julia
addprocs(machines; tunnel=false, sshflags=``, max_parallel=10, kwargs...) -> List of process identifiers
```

SSH 経由でリモートマシンにワーカープロセスを追加します。設定はキーワード引数で行います（以下を参照）。特に、`exename` キーワードを使うと、リモートマシン上の `julia` バイナリへのパスを指定できます。

`machines` は、`[user@]host[:port] [bind_addr[:port]]` 形式の文字列で指定する「マシン指定」のベクトルです。`user` の既定値は現在のユーザー、`port` の既定値は標準の SSH ポートです。`[bind_addr[:port]]` を指定すると、他のワーカーは指定された `bind_addr` と `port` でこのワーカーに接続します。

`machines` ベクトル内でタプルを使うか、`(machine_spec, count)` 形式を使うと、リモートホスト上で複数のプロセスを起動できます。ここで `count` は、指定したホスト上で起動するワーカー数です。ワーカー数に `:auto` を指定すると、リモートホストの CPU スレッド数と同じ数のワーカーが起動します。

**例**:

```julia
addprocs([
    "remote1",               # one worker on 'remote1' logging in with the current username
    "user@remote2",          # one worker on 'remote2' logging in with the 'user' username
    "user@remote3:2222",     # specifying SSH port to '2222' for 'remote3'
    ("user@remote4", 4),     # launch 4 workers on 'remote4'
    ("user@remote5", :auto), # launch as many workers as CPU threads on 'remote5'
])
```

**キーワード引数**:

  * `tunnel`: `true` の場合、マスタープロセスからワーカーへの接続に SSH トンネリングを使用します。既定値は `false` です。
  * `multiplex`: `true` の場合、SSH トンネリングに SSH 多重化を使用します。既定値は `false` です。
  * `ssh`: ワーカーの起動に使用する SSH クライアント実行ファイルの名前またはパスです。既定値は `"ssh"` です。
  * `sshflags`: 追加の SSH オプションを指定します。例: ```sshflags=`-i /home/foo/bar.pem` ```
  * `max_parallel`: ホストごとに並列接続するワーカーの最大数を指定します。既定値は 10 です。
  * `shell`: ワーカー上で SSH が接続するシェルの種類を指定します。

      * `shell=:posix`: POSIX 互換の Unix/Linux シェル（sh、ksh、bash、dash、zsh など）。既定値です。
      * `shell=:csh`: Unix の C シェル（csh、tcsh）。
      * `shell=:wincmd`: Microsoft Windows `cmd.exe`。
  * `dir`: ワーカー上の作業ディレクトリを指定します。既定値は、`pwd()` で取得されるホストの現在のディレクトリです。
  * `enable_threaded_blas`: `true` の場合、追加されたプロセスで BLAS が複数スレッドを使って実行されます。既定値は `false` です。
  * `exename`: `julia` 実行ファイルの名前です。既定値は、状況に応じて `"$(Sys.BINDIR)/julia"` または `"$(Sys.BINDIR)/julia-debug"` です。シリアライズやコード配布に失敗する可能性があるため、すべてのリモートマシンで同じ Julia バージョンを使うことを推奨します。
  * `exeflags`: ワーカープロセスに渡す追加のフラグです。`Cmd`、フラグを 1 つ含む `String`、またはフラグごとに 1 要素を持つ文字列のコレクションを指定できます。例: ``--threads=auto project=.``、`"--compile-trace=stderr"`、`["--threads=auto", "--compile=all"]`。
  * `topology`: ワーカー同士の接続方法を指定します。接続されていないワーカー間でメッセージを送信すると、エラーになります。

      * `topology=:all_to_all`: すべてのプロセスが相互に接続されます。既定値です。
      * `topology=:master_worker`: ドライバープロセス、つまり `pid` 1 のみがワーカーに接続します。ワーカー同士は接続しません。
      * `topology=:custom`: クラスターマネージャーの `launch` メソッドが、`WorkerConfig` 内の `ident` フィールドと `connect_idents` フィールドを使って接続トポロジーを指定します。クラスターマネージャーの ID が `ident` のワーカーは、`connect_idents` に指定されたすべてのワーカーに接続します。
  * `lazy`: `topology=:all_to_all` と併用する場合にのみ適用されます。`true` の場合、ワーカー間の接続は遅延設定され、ワーカー間でリモート呼び出しが初めて行われた時点で確立されます。既定値は true です。
  * `env`: `env=["JULIA_DEPOT_PATH"=>"/depot"]` のような文字列ペアの配列を指定すると、リモートマシン上に環境変数を設定できます。既定では、ローカル環境からリモート環境へ自動的に渡されるのは `JULIA_WORKER_TIMEOUT` 環境変数のみです。
  * `cmdline_cookie`: `--worker` コマンドラインオプションを使って認証 Cookie を渡します。より安全な既定の方法である SSH の標準入出力経由での Cookie の受け渡しは、古い（ConPTY 導入前の）Julia または Windows バージョンを使う Windows ワーカーで停止することがあります。その場合は `cmdline_cookie=true` を回避策として使用できます。

!!! compat "Julia 1.6"
    キーワード引数 `ssh`、`shell`、`env`、`cmdline_cookie` は Julia 1.6 で追加されました。


環境変数:

マスタープロセスが、新たに起動したワーカーとの接続を 60.0 秒以内に確立できない場合、ワーカーは致命的な状況と判断して終了します。このタイムアウトは環境変数 `JULIA_WORKER_TIMEOUT` で制御できます。マスタープロセス上の `JULIA_WORKER_TIMEOUT` の値は、新たに起動したワーカーが接続確立を待つ秒数を指定します。
