```julia
addprocs(machines; tunnel=false, sshflags=``, max_parallel=10, kwargs...) -> プロセス識別子のリスト
```

リモートマシン上にSSHを介してワーカープロセスを追加します。構成はキーワード引数で行います（下記参照）。特に、`exename`キーワードを使用して、リモートマシン上の`julia`バイナリへのパスを指定できます。

`machines`は、`[user@]host[:port] [bind_addr[:port]]`の形式の文字列として与えられる「マシンスペック」のベクターです。`user`は現在のユーザーにデフォルト設定され、`port`は標準SSHポートに設定されます。`[bind_addr[:port]]`が指定されている場合、他のワーカーは指定された`bind_addr`と`port`でこのワーカーに接続します。

`machines`ベクター内でタプルを使用するか、`(machine_spec, count)`の形式を使用することで、リモートホスト上で複数のプロセスを起動することが可能です。ここで、`count`は指定されたホスト上で起動するワーカーの数です。ワーカー数に`:auto`を渡すと、リモートホスト上のCPUスレッドの数と同じ数のワーカーが起動します。

**例**:

```julia
addprocs([
    "remote1",               # 現在のユーザー名でログインして'remote1'に1つのワーカー
    "user@remote2",          # 'user'ユーザー名でログインして'remote2'に1つのワーカー
    "user@remote3:2222",     # 'remote3'のSSHポートを'2222'に指定
    ("user@remote4", 4),     # 'remote4'に4つのワーカーを起動
    ("user@remote5", :auto), # 'remote5'のCPUスレッド数と同じ数のワーカーを起動
])
```

**キーワード引数**:

  * `tunnel`: `true`の場合、マスタープロセスからワーカーに接続するためにSSHトンネリングが使用されます。デフォルトは`false`です。
  * `multiplex`: `true`の場合、SSHトンネリングにSSHマルチプレクシングが使用されます。デフォルトは`false`です。
  * `ssh`: ワーカーを起動するために使用されるSSHクライアント実行可能ファイルの名前またはパス。デフォルトは`"ssh"`です。
  * `sshflags`: 追加のsshオプションを指定します。例: ```sshflags=`-i /home/foo/bar.pem` ```
  * `max_parallel`: ホストに並行して接続される最大ワーカー数を指定します。デフォルトは10です。
  * `shell`: ワーカー上でsshが接続するシェルの種類を指定します。

      * `shell=:posix`: POSIX互換のUnix/Linuxシェル（sh、ksh、bash、dash、zshなど）。デフォルト。
      * `shell=:csh`: Unix Cシェル（csh、tcsh）。
      * `shell=:wincmd`: Microsoft Windows `cmd.exe`。
  * `dir`: ワーカー上の作業ディレクトリを指定します。デフォルトはホストの現在のディレクトリ（`pwd()`で見つけたもの）です。
  * `enable_threaded_blas`: `true`の場合、追加されたプロセスでBLASが複数のスレッドで実行されます。デフォルトは`false`です。
  * `exename`: `julia`実行可能ファイルの名前。デフォルトは`"$(Sys.BINDIR)/julia"`または`"$(Sys.BINDIR)/julia-debug"`です。すべてのリモートマシンで共通のJuliaバージョンを使用することが推奨されます。そうしないと、シリアル化やコード配布が失敗する可能性があります。
  * `exeflags`: ワーカープロセスに渡される追加のフラグ。`Cmd`、1つのフラグを保持する`String`、またはフラグごとに1つの要素を持つ文字列のコレクションである必要があります。例: $--threads=auto project=.$、`"--compile-trace=stderr"`または`["--threads=auto", "--compile=all"]`。
  * `topology`: ワーカーが互いに接続する方法を指定します。接続されていないワーカー間でメッセージを送信するとエラーが発生します。

      * `topology=:all_to_all`: すべてのプロセスが互いに接続されています。デフォルト。
      * `topology=:master_worker`: ドライバープロセス、すなわち`pid` 1のみがワーカーに接続します。ワーカーは互いに接続しません。
      * `topology=:custom`: クラスターマネージャの`launch`メソッドが`WorkerConfig`の`ident`および`connect_idents`フィールドを介して接続トポロジーを指定します。クラスターマネージャのID `ident`を持つワーカーは、`connect_idents`で指定されたすべてのワーカーに接続します。
  * `lazy`: `topology=:all_to_all`の場合のみ適用されます。`true`の場合、ワーカー間の接続は遅延して設定されます。すなわち、ワーカー間のリモート呼び出しの最初のインスタンスで設定されます。デフォルトは`true`です。
  * `env`: `env=["JULIA_DEPOT_PATH"=>"/depot"]`のような文字列ペアの配列を提供して、リモートマシン上で環境変数が設定されるように要求します。デフォルトでは、環境変数`JULIA_WORKER_TIMEOUT`のみが自動的にローカルからリモート環境に渡されます。
  * `cmdline_cookie`: 認証クッキーを`--worker`コマンドラインオプションを介して渡します。クッキーをssh stdioを介して渡す（より安全な）デフォルトの動作は、古い（ConPTY以前の）JuliaまたはWindowsバージョンを使用するWindowsワーカーでハングする可能性があるため、その場合は`cmdline_cookie=true`が回避策を提供します。

!!! compat "Julia 1.6"
    キーワード引数`ssh`、`shell`、`env`および`cmdline_cookie`はJulia 1.6で追加されました。


環境変数:

マスタープロセスが新しく起動したワーカーとの接続を60.0秒以内に確立できない場合、ワーカーはそれを致命的な状況と見なし、終了します。このタイムアウトは環境変数`JULIA_WORKER_TIMEOUT`を介して制御できます。マスタープロセス上の`JULIA_WORKER_TIMEOUT`の値は、新しく起動したワーカーが接続確立を待つ秒数を指定します。
