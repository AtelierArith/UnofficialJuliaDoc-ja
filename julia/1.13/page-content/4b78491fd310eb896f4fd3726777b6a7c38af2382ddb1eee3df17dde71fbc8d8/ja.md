# Environment Variables

Julia は、各オペレーティングシステムで通常の方法を使って設定することも、Julia 内から移植可能な方法で設定することもできる、さまざまな環境変数を利用します。たとえば、環境変数 [`JULIA_EDITOR`](@ref JULIA_EDITOR) を `vim` に設定する場合、`ENV["JULIA_EDITOR"] = "vim"` と入力すれば（たとえば REPL で）、その場限りで変更できます。永続的に設定するには、ユーザーのホームディレクトリにあるユーザー設定ファイル `~/.julia/config/startup.jl` に同じ内容を追加します。環境変数の現在の値は、`ENV["JULIA_EDITOR"]` を評価すると確認できます。

Julia が使用する環境変数の名前は、通常 `JULIA` で始まります。[`InteractiveUtils.versioninfo`](@ref) をキーワード `verbose=true` 付きで呼び出すと、名前に `JULIA` を含むものも含め、Julia に関連する定義済みの環境変数が出力されます。

!!! note
    `~/.julia/config/startup.jl` 内など、実行中に環境変数を変更することは避けることを推奨します。

    その理由の一つは、[`JULIA_NUM_THREADS`](@ref JULIA_NUM_THREADS) や [`JULIA_PROJECT`](@ref JULIA_PROJECT) など、一部の Julia 言語変数は Julia の起動前に設定する必要があるためです。

    同様に、sysimage 内のユーザーモジュールの `__init__()` 関数（PackageCompiler 経由）は `startup.jl` より前に実行されるため、`startup.jl` 内で環境変数を設定しても、ユーザーコードには間に合わない場合があります。

    さらに、実行中に環境変数を変更すると、問題のないコードにデータ競合が生じる可能性があります。

    Bash では、Julia の起動前に `export JULIA_NUM_THREADS=4` などを実行して環境変数を手動で設定するか、Bash の起動時に毎回設定されるよう、同じコマンドを `~/.bashrc` または `~/.bash_profile` に追加できます。


## File locations

### [`JULIA_BINDIR`](@id JULIA_BINDIR)

Julia 実行ファイルを含むディレクトリの絶対パスです。この値によってグローバル変数 [`Sys.BINDIR`](@ref) が設定されます。`$JULIA_BINDIR` が設定されていない場合、Julia は実行時に `Sys.BINDIR` の値を決定します。

実行ファイル自体は、デフォルトでは次のいずれかです。

```
$JULIA_BINDIR/julia
$JULIA_BINDIR/julia-debug
```

グローバル変数 `Base.DATAROOTDIR` は、`Sys.BINDIR` から Julia に関連付けられたデータディレクトリまでの相対パスを指定します。次のパスは、

```
$JULIA_BINDIR/$DATAROOTDIR/julia/base
```

Julia がソースファイルを最初に検索するディレクトリを指定します（`Base.find_source_file()` 経由）。

同様に、グローバル変数 `Base.SYSCONFDIR` は、設定ファイルのディレクトリまでの相対パスを指定します。Julia はデフォルトで、次の場所にある `startup.jl` ファイルを検索します。

```
$JULIA_BINDIR/$SYSCONFDIR/julia/startup.jl
$JULIA_BINDIR/../etc/julia/startup.jl
```

（`Base.load_julia_startup()` 経由）。

たとえば、Julia 実行ファイルが `/bin/julia` にあり、`DATAROOTDIR` が `../share`、`SYSCONFDIR` が `../etc` である Linux インストールでは、[`JULIA_BINDIR`](@ref JULIA_BINDIR) は `/bin` に設定され、ソースファイルの検索パスは次のようになります。

```
/share/julia/base
```

グローバル設定ファイルの検索パスは次のとおりです。

```
/etc/julia/startup.jl
```

### [`JULIA_PROJECT`](@id JULIA_PROJECT)

最初にアクティブにするプロジェクトを示すディレクトリパスです。この環境変数を設定すると、起動オプション `--project` を指定した場合と同じ効果がありますが、`--project` のほうが優先されます。この変数を `@.`（末尾のドットに注意）に設定すると、Julia は現在のディレクトリとその親ディレクトリから、`Project.toml` または `JuliaProject.toml` ファイルを含むプロジェクトディレクトリを探します。[Code Loading](@ref code-loading) の章も参照してください。

!!! note
    [`JULIA_PROJECT`](@ref JULIA_PROJECT) は Julia の起動前に定義する必要があります。`startup.jl` 内で定義しても、起動処理のタイミングとしては遅すぎます。


### [`JULIA_LOAD_PATH`](@id JULIA_LOAD_PATH)

[`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) 環境変数は、グローバルな Julia の [`LOAD_PATH`](@ref) 変数の値を設定するために使われます。この変数は、`import` および `using` で読み込めるパッケージを決定します（[Code Loading](@ref code-loading) を参照）。

シェルの `PATH` 変数とは異なり、[`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) の空の要素は、`LOAD_PATH` の値を設定する際に、`LOAD_PATH`、`["@", "@v#.#", "@stdlib"]` のデフォルト値に展開されます。そのため、[`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) が設定済みかどうかにかかわらず、シェルスクリプトからロードパスの値を簡単に追加・先頭への挿入などができます。たとえば、ディレクトリ `/foo/bar` を `LOAD_PATH` の先頭に追加するには、次のようにします。

```sh
export JULIA_LOAD_PATH="/foo/bar:$JULIA_LOAD_PATH"
```

[`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) 環境変数がすでに設定されている場合は、その古い値の前に `/foo/bar` が追加されます。一方、[`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) が設定されていない場合は、`/foo/bar:` に設定され、これは `LOAD_PATH` の値 `["/foo/bar", "@", "@v#.#", "@stdlib"]` に展開されます。[`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) が空文字列に設定されている場合は、空の `LOAD_PATH` 配列に展開されます。つまり、空文字列は空文字列を要素とする1要素の配列ではなく、要素数0の配列として解釈されます。この動作により、環境変数を使って空のロードパスを設定できます。デフォルトのロードパスを使うには、環境変数の設定を解除するか、値を設定する必要がある場合は文字列 `:` を設定してください。

!!! note
    Windows では、ほとんどのパスリストと同様に、パス要素は `;` 文字で区切られます。上記の段落にある `:` は `;` に置き換えてください。


### [`JULIA_DEPOT_PATH`](@id JULIA_DEPOT_PATH)

[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) 環境変数は、グローバルな Julia の [`DEPOT_PATH`](@ref) 変数の値を設定するために使われます。この変数は、パッケージマネージャーと Julia のコード読み込み機構が、パッケージレジストリ、インストール済みパッケージ、名前付き環境、リポジトリのクローン、コンパイル済みパッケージイメージのキャッシュ、設定ファイル、および REPL の履歴ファイルのデフォルト保存先を検索する場所を制御します。

シェルの `PATH` 変数とは異なりますが、[`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) と同様に、[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) の空の要素には特別な動作があります。

  * 末尾にある場合、ユーザーデポを*除く* `DEPOT_PATH` のデフォルト値に展開されます。
  * 先頭にある場合、ユーザーデポを*含む* `DEPOT_PATH` のデフォルト値に展開されます。

これにより、Julia に同梱されているキャッシュファイルやアーティファクトなどのリソースへのアクセスを維持しながら、ユーザーデポを簡単に上書きできます。たとえば、ユーザーデポを `/foo/bar` に切り替えるには、末尾に `:` を付けます。

```sh
export JULIA_DEPOT_PATH="/foo/bar:"
```

レジストリのクローンやパッケージのインストールなど、すべてのパッケージ操作は `/foo/bar` に書き込まれるようになります。ただし、空の要素はデフォルトのシステムデポに展開されるため、同梱リソースも引き続き利用できます。同梱リソースを読み込まず、`/foo/bar` のデポだけを使いたい場合は、末尾のコロンを付けずに環境変数を `/foo/bar` に設定してください。

デフォルトのユーザーデポを含むデフォルトリスト全体の末尾にデポを追加するには、先頭に `:` を付けます。

```sh
export JULIA_DEPOT_PATH=":/foo/bar"
```

上記の規則には例外が2つあります。まず、[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) が空文字列に設定されている場合は、空の `DEPOT_PATH` 配列に展開されます。つまり、空文字列は空文字列を要素とする1要素の配列ではなく、要素数0の配列として解釈されます。この動作により、環境変数を使って空のデポパスを設定できます。

2つ目に、[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) にユーザーデポが指定されていない場合、空の要素はユーザーデポを*含む*デフォルトのデポに展開されます。これにより、環境変数の設定を解除した場合と同じようにデフォルトのデポを使うには、値を文字列 `:` に設定すればよくなります。

!!! note
    Windows では、ほとんどのパスリストと同様に、パス要素は `;` 文字で区切られます。上記の段落にある `:` は `;` に置き換えてください。


!!! note
    [`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) は Julia の起動前に定義する必要があります。`startup.jl` 内で定義しても起動処理のタイミングとしては遅すぎます。その時点では、環境変数から設定される `DEPOT_PATH` 配列を直接変更できます。


### [`JULIA_HISTORY`](@id JULIA_HISTORY)

REPL の履歴ファイルの絶対パス `REPL.find_hist_file()` です。`$JULIA_HISTORY` が設定されていない場合、`REPL.find_hist_file()` のデフォルト値は次のとおりです。

```
$(DEPOT_PATH[1])/logs/repl_history.jl
```

### [`JULIA_MAX_NUM_PRECOMPILE_FILES`](@id JULIA_MAX_NUM_PRECOMPILE_FILES)

プリコンパイルキャッシュに保存する、単一パッケージの異なるインスタンスの最大数を設定します（デフォルトは10）。

### [`JULIA_VERBOSE_LINKING`](@id JULIA_VERBOSE_LINKING)

true に設定すると、プリコンパイル中にリンカーコマンドが表示されます。

## Pkg.jl

### [`JULIA_CI`](@id JULIA_CI)

`true` に設定すると、パッケージサーバーに対し、パッケージ操作がパッケージ利用統計の収集を目的とした継続的インテグレーション（CI）システムの一部であることを示します。

### [`JULIA_NUM_PRECOMPILE_TASKS`](@id JULIA_NUM_PRECOMPILE_TASKS)

パッケージのプリコンパイル時に使用する並列タスク数です。[`Pkg.precompile`](https://pkgdocs.julialang.org/v1/api/#Pkg.precompile) を参照してください。

### [`JULIA_PKG_DEVDIR`](@id JULIA_PKG_DEVDIR)

[`Pkg.develop`](https://pkgdocs.julialang.org/v1/api/#Pkg.develop) がパッケージをダウンロードする際に使用するデフォルトのディレクトリです。

### [`JULIA_PKG_IGNORE_HASHES`](@id JULIA_PKG_IGNORE_HASHES)

`1` に設定すると、アーティファクトのハッシュが正しくない場合でも無視します。ダウンロードの検証が無効になるため、慎重に使用してください。ただし、異なる種類のファイルシステム間でファイルを移動する際の問題を解決できる場合があります。詳しくは [Pkg.jl issue #2317](https://github.com/JuliaLang/Pkg.jl/issues/2317) を参照してください。

!!! compat "Julia 1.6"
    Julia 1.6 以降でのみサポートされています。


### [`JULIA_PKG_OFFLINE`](@id JULIA_PKG_OFFLINE)

`true` に設定すると、オフラインモードが有効になります。[`Pkg.offline`](https://pkgdocs.julialang.org/v1/api/#Pkg.offline) を参照してください。

!!! compat "Julia 1.5"
    Pkg のオフラインモードには Julia 1.5 以降が必要です。


### [`JULIA_PKG_PRECOMPILE_AUTO`](@id JULIA_PKG_PRECOMPILE_AUTO)

`0` に設定すると、マニフェストを変更するパッケージ操作による自動プリコンパイルが無効になります。[`Pkg.precompile`](https://pkgdocs.julialang.org/v1/api/#Pkg.precompile) を参照してください。

### [`JULIA_PKG_SERVER`](@id JULIA_PKG_SERVER)

使用するパッケージレジストリの URL を指定します。デフォルトでは、`Pkg` は `https://pkg.julialang.org` を使って Julia パッケージを取得します。また、PkgServer プロトコルを使わず、パッケージのホスト（GitHub、GitLab など）から直接アクセスするには、次のように設定します。`export JULIA_PKG_SERVER=""`

### [`JULIA_PKG_SERVER_REGISTRY_PREFERENCE`](@id JULIA_PKG_SERVER_REGISTRY_PREFERENCE)

優先するレジストリの種類を指定します。現在サポートされている値は `conservative`（デフォルト）と `eager` です。前者はストレージサーバーで処理済みのリソースのみを公開するため、PkgServer から利用できる可能性が高くなります。後者は、ストレージサーバーで処理されていないリソースを含むレジストリも公開します。任意のサーバーからのダウンロードを許可しない制限の厳しいファイアウォールの内側にいるユーザーは、`eager` の種類を使用しないでください。

!!! compat "Julia 1.7"
    Julia 1.7 以降でのみ影響します。


### [`JULIA_PKG_UNPACK_REGISTRY`](@id JULIA_PKG_UNPACK_REGISTRY)

`true` に設定すると、レジストリを圧縮 tarball として保存せずに展開します。

!!! compat "Julia 1.7"
    Julia 1.7 以降でのみ影響します。それより前のバージョンでは、レジストリは常に展開されます。


### [`JULIA_PKG_USE_CLI_GIT`](@id JULIA_PKG_USE_CLI_GIT)

`true` に設定すると、git プロトコルを使う Pkg 操作では、デフォルトの libgit2 ライブラリの代わりに外部の `git` 実行ファイルを使用します。

!!! compat "Julia 1.7"
    `git` 実行ファイルの使用は Julia 1.7 以降でのみサポートされています。


### [`JULIA_PKGRESOLVE_ACCURACY`](@id JULIA_PKGRESOLVE_ACCURACY)

パッケージリゾルバーの精度です。正の整数を指定します。デフォルトは `1` です。

### [`JULIA_PKG_PRESERVE_TIERED_INSTALLED`](@id JULIA_PKG_PRESERVE_TIERED_INSTALLED)

デフォルトのパッケージインストール戦略を `Pkg.PRESERVE_TIERED_INSTALLED` に変更します。これにより、パッケージマネージャーは、すでにインストールされているパッケージのバージョンをできるだけ多く維持しながら、パッケージのバージョンをインストールしようとします。

!!! compat "Julia 1.9"
    Julia 1.9 以降でのみ影響します。


### [`JULIA_PKG_GC_AUTO`](@id JULIA_PKG_GC_AUTO)

`false` に設定すると、パッケージとアーティファクトの自動ガベージコレクションが無効になります。詳しくは [`Pkg.gc`](https://pkgdocs.julialang.org/v1/api/#Pkg.gc) を参照してください。

!!! compat "Julia 1.12"
    この環境変数は Julia 1.12 以降でのみサポートされています。


## Network transport

### [`JULIA_NO_VERIFY_HOSTS`](@id JULIA_NO_VERIFY_HOSTS)

### [`JULIA_SSL_NO_VERIFY_HOSTS`](@id JULIA_SSL_NO_VERIFY_HOSTS)

### [`JULIA_SSH_NO_VERIFY_HOSTS`](@id JULIA_SSH_NO_VERIFY_HOSTS)

### [`JULIA_ALWAYS_VERIFY_HOSTS`](@id JULIA_ALWAYS_VERIFY_HOSTS)

特定のトランスポート層について、本人確認を行うホスト、または行わないホストを指定します。[`NetworkOptions.verify_host`](https://github.com/JuliaLang/NetworkOptions.jl#verify_host) を参照してください。

### [`JULIA_SSL_CA_ROOTS_PATH`](@id JULIA_SSL_CA_ROOTS_PATH)

認証局のルート証明書を含むファイルまたはディレクトリを指定します。[`NetworkOptions.ca_roots`](https://github.com/JuliaLang/NetworkOptions.jl#ca_roots) を参照してください。

## External applications

### [`JULIA_SHELL`](@id JULIA_SHELL)

Julia が外部コマンドの実行に使用するシェルの絶対パスです（`Base.repl_cmd()` 経由）。デフォルトでは環境変数 `$SHELL` の値を使い、`$SHELL` が設定されていない場合は `/bin/sh` にフォールバックします。

!!! note
    Windows ではこの環境変数は無視され、外部コマンドは直接実行されます。


### [`JULIA_EDITOR`](@id JULIA_EDITOR)

`InteractiveUtils.editor()` が返すエディターです。たとえば [`InteractiveUtils.edit`](@ref) などで使用され、優先するエディターのコマンドを指定します。例：`vim`。

`$JULIA_EDITOR` は `$VISUAL` より優先され、後者は `$EDITOR` より優先されます。これらの環境変数がいずれも設定されていない場合、Windows と OS X では `open` がエディターとして使われます。それ以外では、`/etc/alternatives/editor` が存在すればそれを使い、存在しなければ `emacs` を使います。

Windows で Visual Studio Code を使うには、`$JULIA_EDITOR` を `code.cmd` に設定します。

## Parallelization

### [`JULIA_CPU_THREADS`](@id JULIA_CPU_THREADS)

使用可能な論理 CPU コア数を示すグローバル変数 [`Base.Sys.CPU_THREADS`](@ref) を上書きします。

### [`JULIA_WORKER_TIMEOUT`](@id JULIA_WORKER_TIMEOUT)

[`Float64`](@ref) で、`Distributed.worker_timeout()` の値を設定します（デフォルト：`60.0`）。この関数は、ワーカープロセスがマスタープロセスとの接続確立を待つ秒数を指定します。時間内に接続できない場合、ワーカープロセスは終了します。

### [`JULIA_NUM_THREADS`](@id JULIA_NUM_THREADS)

Julia が使用できるスレッドの最大数を設定する、符号なし64ビット整数（`uint64_t`）または文字列です。`$JULIA_NUM_THREADS` が未設定、正でない整数、またはシステムコールで CPU スレッド数を取得できない場合、スレッド数は `1` に設定されます。

`$JULIA_NUM_THREADS` を `auto` に設定すると、スレッド数は CPU スレッド数と同じになります。また、カンマ区切りの文字列を指定して、それぞれ `:default` と `:interactive` の [threadpools](@ref man-threadpools) のサイズを指定することもできます。

```bash
# 5 threads in the :default pool and 2 in the :interactive pool
export JULIA_NUM_THREADS=5,2

# `auto` threads in the :default pool and 1 in the :interactive pool
export JULIA_NUM_THREADS=auto,1
```

!!! note
    `JULIA_NUM_THREADS` は Julia の起動前に定義する必要があります。`startup.jl` 内で定義しても、起動処理のタイミングとしては遅すぎます。


!!! compat "Julia 1.5"
    Julia 1.5 以降では、起動時に `-t`/`--threads` コマンドライン引数を使ってスレッド数を指定することもできます。


!!! compat "Julia 1.7"
    `$JULIA_NUM_THREADS` に `auto` の値を指定するには、Julia 1.7 以降が必要です。


!!! compat "Julia 1.9"
    スレッドプールに `x,y` 形式を使うには、Julia 1.9 以降が必要です。


### [`JULIA_THREAD_SLEEP_THRESHOLD`](@id JULIA_THREAD_SLEEP_THRESHOLD)

大文字と小文字を区別せず、部分文字列 `"infinite"` で始まる文字列に設定すると、スピニングスレッドはスリープしません。それ以外の場合、`$JULIA_THREAD_SLEEP_THRESHOLD` は符号なし64ビット整数（`uint64_t`）として解釈され、スピニングスレッドがスリープするまでの時間をナノ秒単位で指定します。

### [`JULIA_NUM_GC_THREADS`](@id JULIA_NUM_GC_THREADS)

ガベージコレクションで使用するスレッド数を設定します。指定しない場合は、ワーカースレッド数が使われます。

!!! compat "Julia 1.10"
    この環境変数は Julia 1.10 で追加されました。


### [`JULIA_IMAGE_THREADS`](@id JULIA_IMAGE_THREADS)

この Julia プロセスでイメージのコンパイルに使用するスレッド数を設定する、符号なし32ビット整数です。モジュールが小さい場合、この変数の値は無視されることがあります。未指定の場合は、[`JULIA_CPU_THREADS`](@ref JULIA_CPU_THREADS) の値と論理 CPU コア数の半分のうち、小さいほうが使われます。

### [`JULIA_IMAGE_TIMINGS`](@id JULIA_IMAGE_TIMINGS)

イメージのコンパイル中に詳細なタイミング情報を出力するかどうかを指定するブール値です。デフォルトは 0 です。

### [`JULIA_EXCLUSIVE`](@id JULIA_EXCLUSIVE)

`0` 以外の値に設定すると、専用マシンで実行する場合と同じスレッドポリシーが適用されます。デフォルトのスレッドプール内の各スレッドには、CPU アフィニティが設定されます。[Interactive threads](@ref man-threadpools) は引き続きオペレーティングシステムのスケジューラーが制御します。

それ以外の場合、Julia はスレッドポリシーの制御をオペレーティングシステムに任せます。

## Garbage Collection

### [`JULIA_HEAP_SIZE_HINT`](@id JULIA_HEAP_SIZE_HINT)

`--heap-size-hint=<size>[<unit>]` コマンドラインオプションに相当する環境変数です。

メモリ使用量が指定値を超えた場合にガベージコレクションを強制します。値はバイト数で指定でき、次の単位を付けることもできます。

```
- B  (bytes)
- K  (kibibytes)
- M  (mebibytes)
- G  (gibibytes)
- T  (tebibytes)
- %  (percentage of physical memory)
```

たとえば、`JULIA_HEAP_SIZE_HINT=1G` を指定すると、ガベージコレクターにヒープサイズの目安として 1 GB を与えます。

## REPL formatting

REPL の出力を端末でどのように整形するかを決める環境変数です。`JULIA_*_COLOR` 変数には [ANSI terminal escape sequences](https://en.wikipedia.org/wiki/ANSI_escape_code) を設定してください。Julia には同様の機能の多くを備えた高水準インターフェースもあります。[The Julia REPL](@ref) の節を参照してください。

### [`JULIA_ERROR_COLOR`](@id JULIA_ERROR_COLOR)

端末でエラーに使用する書式 `Base.error_color()` です（デフォルト：薄い赤、`"\033[91m"`）。

### [`JULIA_WARN_COLOR`](@id JULIA_WARN_COLOR)

端末で警告に使用する書式 `Base.warn_color()` です（デフォルト：黄色、`"\033[93m"`）。

### [`JULIA_INFO_COLOR`](@id JULIA_INFO_COLOR)

端末で情報メッセージに使用する書式 `Base.info_color()` です（デフォルト：シアン、`"\033[36m"`）。

### [`JULIA_INPUT_COLOR`](@id JULIA_INPUT_COLOR)

端末で入力に使用する書式 `Base.input_color()` です（デフォルト：標準、`"\033[0m"`）。

### [`JULIA_ANSWER_COLOR`](@id JULIA_ANSWER_COLOR)

端末で出力に使用する書式 `Base.answer_color()` です（デフォルト：標準、`"\033[0m"`）。

### [`NO_COLOR`](@id NO_COLOR)

この変数が存在し、空文字列でない場合（値は問いません）、REPL の色付きテキストが無効になります。フラグ `--color=yes` または環境変数 [`FORCE_COLOR`](@ref FORCE_COLOR) で上書きできます。この環境変数は [commonly recognized by command-line applications](https://no-color.org/) です。

### [`FORCE_COLOR`](@id FORCE_COLOR)

この変数が存在し、空文字列でない場合（値は問いません）、REPL の色付きテキストが有効になります。フラグ `--color=no` で上書きできます。この環境変数は [commonly recognized by command-line applications](https://force-color.org/) です。

## System and Package Image Building

### [`JULIA_CPU_TARGET`](@id JULIA_CPU_TARGET)

[system](@ref sysimg-multi-versioning) と [package images](@ref pkgimgs-multi-versioning) の（プリ）コンパイルで使用するターゲットマシンのアーキテクチャを変更します。`JULIA_CPU_TARGET` が影響するのは、ディスクキャッシュに出力されるマシンコードイメージの生成だけです。`--cpu-target` や `-C` の [command line option](@ref cli) とは異なり、マシンコードがメモリにのみ保存される Julia セッション内のジャストインタイム（JIT）コード生成には影響しません。

[`JULIA_CPU_TARGET`](@ref JULIA_CPU_TARGET) に指定できる値は、`julia -C help` を実行すると取得できます。

現在のシステムイメージのビルドに使われた CPU ターゲット文字列を取得するには、[`Sys.sysimage_target()`](@ref) を使います。これは、同じシステムイメージを再現したり、コンパイル時に有効だった CPU 機能を確認したりする際に役立ちます。

プロセッサの種類や機能が異なるシステムが混在する環境では、[`JULIA_CPU_TARGET`](@ref JULIA_CPU_TARGET) の設定が重要です。これは、構成ノードごとに異なるプロセッサが使われることのある高性能計算（HPC）クラスターでよく見られます。この場合、sysimage と同じ構成を維持するために、`sysimage` CPU ターゲットを使うとよいでしょう。詳しくは以下を参照してください。

CPU ターゲット文字列は、`;` で区切られた文字列のリストです。各文字列は CPU 名またはアーキテクチャ名で始まり、その後に `,` で区切られた機能のリストを任意で指定できます。`generic` または空の CPU 名は、ターゲット ISA の基本必須機能セットを意味します。これは少なくとも、C/C++ ランタイムのコンパイルに使われたアーキテクチャに相当します。各文字列は LLVM によって解釈されます。

!!! note
    パッケージイメージの CPU 機能ターゲットは、ベースとなるシステムイメージと同じか、それより具体的なものに限られます。


いくつかの特殊な機能がサポートされています。

1. `sysimage`

    CPU ターゲット名として使える特殊なキーワードです。現在のシステムイメージのビルドに使われた CPU ターゲット文字列に置き換えられます。これにより、現在の sysimage のターゲットを基にしたり拡張したりする CPU ターゲットを指定できます。sysimage と同程度に柔軟なパッケージイメージを作成する場合に特に便利です。
2. `clone_all`

    sysimg 内のすべての関数をクローンするようターゲットに強制します。否定形（つまり `-clone_all`）で使うと、一部のターゲットでデフォルトで有効になっている完全クローンを無効にします。
3. `base([0-9]*)`

    ベースターゲットのインデックス（0始まり）を指定します。ベースターゲットとは、現在のターゲットの基になるターゲットです。クローンされない関数には、ベースターゲットのバージョンが使われます。このオプションを指定すると、ベースターゲットがデフォルトのターゲット（0）でない場合、そのターゲットは完全にクローンされます（そのターゲットに `clone_all` を指定した場合と同様）。インデックスは現在のインデックスより小さくなければなりません。
4. `opt_size`

    パフォーマンスへの影響を最小限に抑えながら、サイズを最適化します。Clang/GCC の `-Os` に相当します。
5. `min_size`

    サイズのみを最適化します。Clang の `-Oz` に相当します。

## Debugging and profiling

### [`JULIA_DEBUG`](@id JULIA_DEBUG)

ファイルまたはモジュールのデバッグログを有効にします。詳しくは [`Logging`](@ref man-logging) を参照してください。

### CI Debug Environment Variables

特定の継続的インテグレーション（CI）デバッグ環境変数が設定されている場合、Julia は詳細なデバッグオプションを自動的に有効にします。これにより、デバッグログを有効にして CI ジョブを再実行する際、次の設定が自動で行われ、デバッグしやすくなります。

  * `--trace-eval`（location モード）を有効にし、評価中の式を表示する
  * 詳細なテスト出力を有効にするため、`JULIA_TEST_VERBOSE=true` を設定する

これにより、スクリプトやワークフローファイルを変更せずに、CI 実行から詳細なデバッグ情報を取得できます。

### [`JULIA_PROFILE_PEEK_HEAP_SNAPSHOT`](@id JULIA_PROFILE_PEEK_HEAP_SNAPSHOT)

プロファイリングの peek 機構を使って、実行中にヒープスナップショットを収集できるようにします。[Triggered During Execution](@ref) を参照してください。

### [`JULIA_TIMING_SUBSYSTEMS`](@id JULIA_TIMING_SUBSYSTEMS)

特定の Julia 実行でゾーンを有効または無効にできます。たとえば、この変数を `+GC,-INFERENCE` に設定すると、`GC` ゾーンが有効になり、`INFERENCE` ゾーンが無効になります。[Dynamically Enabling and Disabling Zones](@ref) を参照してください。

### [`JULIA_GC_WAIT_FOR_DEBUGGER`](@id JULIA_GC_WAIT_FOR_DEBUGGER)

`0` 以外の値に設定すると、重大なエラーが発生した際、Julia のガベージコレクターは異常終了せず、デバッガーが接続するまで待機します。

!!! note
    この環境変数が効果を持つのは、Julia がガベージコレクションのデバッグ機能を有効にしてコンパイルされている場合に限ります（つまり、ビルド設定で `WITH_GC_DEBUG_ENV` が `1` に設定されている場合）。


### [`ENABLE_JITPROFILING`](@id ENABLE_JITPROFILING)

`0` 以外の値に設定すると、コンパイラーはジャストインタイム（JIT）プロファイリング用のイベントリスナーを作成して登録します。

!!! note
    この環境変数が効果を持つのは、次のいずれかを使って Julia が JIT プロファイリング対応でコンパイルされている場合に限ります。

      * Intel の [VTune™ Amplifier](https://software.intel.com/en-us/vtune)（ビルド設定で `USE_INTEL_JITEVENTS` が `1` に設定されている場合）、または
      * [OProfile](https://oprofile.sourceforge.io/news/)（ビルド設定で `USE_OPROFILE_JITEVENTS` が `1` に設定されている場合）。
      * [Perf](https://perf.wiki.kernel.org)（ビルド設定で `USE_PERF_JITEVENTS` が `1` に設定されている場合）。この統合はデフォルトで有効です。


### [`ENABLE_GDBLISTENER`](@id ENABLE_GDBLISTENER)

`0` 以外の値に設定すると、リリースビルドで Julia コードの GDB 登録が有効になります。Julia のデバッグビルドでは常に有効です。`-g 2` と併用することを推奨します。

### [`JULIA_LLVM_ARGS`](@id JULIA_LLVM_ARGS)

LLVM バックエンドに渡す引数です。

### `JULIA_FALLBACK_REPL`

REPL.jl の代わりにフォールバック REPL を強制的に使用します。

### `JULIA_LOAD_CODEGEN_LIB`

偽の値（大文字と小文字を区別せず、`0`、`f`、`false`、`n`、`no` のいずれか）に設定すると、ローダーは `libjulia-codegen` を読み込まず、代わりに `libjulia-internal` のフォールバック実装（インタープリターのみ）を使用します。これは、ライブラリがインストールされていない場合とまったく同じ動作です。コード生成なしの構成をテストおよびデバッグするための設定です。
