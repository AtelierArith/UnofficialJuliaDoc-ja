```julia
addprocs(machines; tunnel=false, sshflags=``, max_parallel=10, kwargs...) -> List of process identifiers
```

SSH経由でリモートマシンにワーカープロセスを追加します。設定はキーワード引数で行います（以下を参照）。特に、`exename`キーワードを使うと、リモートマシン上の`julia`バイナリへのパスを指定できます。

`machines`は、`[user@]host[:port] [bind_addr[:port]]`形式の文字列で指定する「マシン指定」のベクトルです。`user`の既定値は現在のユーザー、`port`の既定値は標準のSSHポートです。`[bind_addr[:port]]`を指定すると、他のワーカーは指定された`bind_addr`および`port`でこのワーカーに接続します。

`machines`ベクトル内でタプルを使うか、`(machine_spec, count)`形式を使うと、リモートホスト上で複数のプロセスを起動できます。ここで`count`は、指定したホスト上で起動するワーカー数です。ワーカー数に`:auto`を指定すると、リモートホスト上のCPUスレッド数と同じ数のワーカーが起動します。

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

  * `tunnel`: `true`の場合、マスタープロセスからワーカーへの接続にSSHトンネリングを使用します。既定値は`false`です。
  * `multiplex`: `true`の場合、SSHトンネリングにSSH多重化を使用します。既定値は`false`です。
  * `ssh`: ワーカーの起動に使用するSSHクライアント実行ファイルの名前またはパスです。既定値は`"ssh"`です。
  * `sshflags`: 追加のSSHオプションを指定します。例: ```sshflags=`-i /home/foo/bar.pem` ```
  * `max_parallel`: ホストごとに並列接続するワーカーの最大数を指定します。既定値は10です。
  * `shell`: ワーカー上でSSHが接続するシェルの種類を指定します。

      * `shell=:posix`: POSIX互換のUnix/Linuxシェル（sh、ksh、bash、dash、zshなど）。既定値です。
      * `shell=:csh`: UnixのCシェル（csh、tcsh）。
      * `shell=:wincmd`: Microsoft Windows `cmd.exe`。
  * `dir`: ワーカー上の作業ディレクトリを指定します。既定値は、ホストの現在のディレクトリ（`pwd()`で取得）です。
  * `enable_threaded_blas`: `true`の場合、追加されたプロセスでBLASが複数スレッドを使って実行されます。既定値は`false`です。
  * `exename`: `julia`実行ファイルの名前です。既定値は、状況に応じて`"$(Sys.BINDIR)/julia"`または`"$(Sys.BINDIR)/julia-debug"`です。シリアライズやコード配布に失敗する可能性があるため、すべてのリモートマシンで同じJuliaバージョンを使うことを推奨します。
  * `exeflags`: ワーカープロセスに渡す追加のフラグです。`Cmd`、フラグを1つ格納した`String`、またはフラグごとに1要素を持つ文字列のコレクションを指定できます。例: ``--threads=auto project=.``、`"--compile-trace=stderr"`、`["--threads=auto", "--compile=all"]`。
  * `topology`: ワーカー同士の接続方法を指定します。接続されていないワーカー間でメッセージを送信するとエラーになります。

      * `topology=:all_to_all`: すべてのプロセスが相互に接続されます。既定値です。
      * `topology=:master_worker`: ドライバープロセス、つまり`pid` 1のみがワーカーに接続します。ワーカー同士は接続されません。
      * `topology=:custom`: クラスターマネージャーの`launch`メソッドが、`WorkerConfig`内の`ident`および`connect_idents`フィールドを使って接続トポロジーを指定します。クラスターマネージャー上の識別子が`ident`であるワーカーは、`connect_idents`で指定されたすべてのワーカーに接続します。
  * `lazy`: `topology=:all_to_all`の場合にのみ適用されます。`true`の場合、ワーカー間の接続は遅延して確立されます。つまり、ワーカー間でリモート呼び出しが初めて行われた時点で接続が確立されます。既定値はtrueです。
  * `env`: `env=["JULIA_DEPOT_PATH"=>"/depot"]`のような文字列ペアの配列を指定すると、リモートマシン上に環境変数を設定できます。既定では、環境変数`JULIA_WORKER_TIMEOUT`のみがローカル環境からリモート環境へ自動的に渡されます。
  * `cmdline_cookie`: `--worker`コマンドラインオプションを使って認証クッキーを渡します。より安全な既定の方法であるSSHの標準入出力経由でのクッキーの受け渡しは、古い（ConPTY以前の）JuliaまたはWindowsバージョンを使うWindowsワーカーで停止することがあります。その場合、`cmdline_cookie=true`を使うと回避できます。

!!! compat "Julia 1.6"
    キーワード引数`ssh`、`shell`、`env`、`cmdline_cookie`はJulia 1.6で追加されました。


環境変数:

マスタープロセスが、新たに起動したワーカーとの接続を60.0秒以内に確立できない場合、ワーカーは致命的な状況と判断して終了します。このタイムアウトは環境変数`JULIA_WORKER_TIMEOUT`で制御できます。マスタープロセス上の`JULIA_WORKER_TIMEOUT`の値は、新たに起動したワーカーが接続確立を待つ秒数を指定します。
