# Environment Variables

Juliaは、各オペレーティングシステムの通常の方法で、またはJulia内からポータブルな方法で設定できる多くの環境変数を持っています。環境変数 [`JULIA_EDITOR`](@ref JULIA_EDITOR) を `vim` に設定したい場合、`ENV["JULIA_EDITOR"] = "vim"` と入力することで（例えば、REPL内で）この変更をケースバイケースで行うことができます。また、ユーザーのホームディレクトリにあるユーザー設定ファイル `~/.julia/config/startup.jl` に同じ内容を追加することで、永続的な効果を得ることができます。同じ環境変数の現在の値は、`ENV["JULIA_EDITOR"]` を評価することで確認できます。

Juliaが使用する環境変数は一般的に`JULIA`で始まります。[`InteractiveUtils.versioninfo`](@ref)がキーワード`verbose=true`で呼び出されると、出力には`JULIA`を名前に含む、Juliaに関連する定義済みの環境変数がリストされます。

!!! note
    実行時に環境変数を変更することは避けることが推奨されます。たとえば、`~/.julia/config/startup.jl`内での変更です。

    一つの理由は、[`JULIA_NUM_THREADS`](@ref JULIA_NUM_THREADS)や[`JULIA_PROJECT`](@ref JULIA_PROJECT)のような一部のJulia言語の変数は、Juliaが起動する前に設定する必要があるためです。

    同様に、sysimage内のユーザーモジュールの`__init__()`関数は`startup.jl`の前に実行されるため、`startup.jl`で環境変数を設定するのはユーザーコードにとっては遅すぎるかもしれません。

    さらに、実行時に環境変数を変更すると、無害なコードにデータ競合が発生する可能性があります。

    Bashでは、環境変数は手動で設定することができます。例えば、`export JULIA_NUM_THREADS=4`を実行してからJuliaを起動するか、同じコマンドを`~/.bashrc`または`~/.bash_profile`に追加して、Bashが起動するたびに変数を設定することができます。


## File locations

### [`JULIA_BINDIR`](@id JULIA_BINDIR)

Julia実行可能ファイルを含むディレクトリの絶対パスで、グローバル変数 [`Sys.BINDIR`](@ref) を設定します。`$JULIA_BINDIR` が設定されていない場合、Juliaは実行時に `Sys.BINDIR` の値を決定します。

実行可能ファイル自体はその一つです。

```
$JULIA_BINDIR/julia
$JULIA_BINDIR/julia-debug
```

デフォルトでは。

グローバル変数 `Base.DATAROOTDIR` は、`Sys.BINDIR` から Julia に関連付けられたデータディレクトリへの相対パスを決定します。次に、そのパスは

```
$JULIA_BINDIR/$DATAROOTDIR/julia/base
```

Juliaが最初にソースファイルを検索するディレクトリを決定します（`Base.find_source_file()`を介して）。

同様に、グローバル変数 `Base.SYSCONFDIR` は設定ファイルディレクトリへの相対パスを決定します。次に、Juliaは `startup.jl` ファイルを探します。

```
$JULIA_BINDIR/$SYSCONFDIR/julia/startup.jl
$JULIA_BINDIR/../etc/julia/startup.jl
```

デフォルトでは（`Base.load_julia_startup()`を介して）。

例えば、`/bin/julia`にあるJulia実行可能ファイルを持ち、`DATAROOTDIR`が`../share`、`SYSCONFDIR`が`../etc`のLinuxインストールでは、[`JULIA_BINDIR`](@ref JULIA_BINDIR)が`/bin`に設定され、ソースファイルの検索パスは

```
/share/julia/base
```

およびグローバル設定検索パスの

```
/etc/julia/startup.jl
```

### [`JULIA_PROJECT`](@id JULIA_PROJECT)

初期アクティブプロジェクトを示すディレクトリパス。この環境変数を設定することは、`--project` スタートアップオプションを指定するのと同じ効果がありますが、`--project` の方が優先されます。変数が `@.` に設定されている場合（末尾のドットに注意）、Julia は現在のディレクトリとその親ディレクトリから `Project.toml` または `JuliaProject.toml` ファイルを含むプロジェクトディレクトリを探そうとします。詳細は [Code Loading](@ref code-loading) の章も参照してください。

!!! note
    [`JULIA_PROJECT`](@ref JULIA_PROJECT) は、juliaを開始する前に定義する必要があります。`startup.jl` で定義するのは、起動プロセスの中では遅すぎます。


### [`JULIA_LOAD_PATH`](@id JULIA_LOAD_PATH)

[`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) 環境変数は、グローバルな Julia [`LOAD_PATH`](@ref) 変数を設定するために使用され、どのパッケージが `import` および `using` を介してロードできるかを決定します（[Code Loading](@ref code-loading) を参照）。

[`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH)に空のエントリがある場合、`LOAD_PATH`を設定する際に、空のエントリはデフォルト値`LOAD_PATH`の`["@", "@v#.#", "@stdlib"]`に展開されます。これにより、`4d61726b646f776e2e436f64652822222c20224a554c49415f4c4f41445f504154482229_40726566204a554c49415f4c4f41445f50415448`がすでに設定されているかどうかに関係なく、シェルスクリプトでロードパスの値を簡単に追加、前置きなどができます。たとえば、ディレクトリ`/foo/bar`を`LOAD_PATH`の前に追加するには、次のようにします。

```sh
export JULIA_LOAD_PATH="/foo/bar:$JULIA_LOAD_PATH"
```

もし [`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) 環境変数がすでに設定されている場合、その古い値は `/foo/bar` で前置きされます。一方、`4d61726b646f776e2e436f64652822222c20224a554c49415f4c4f41445f504154482229_40726566204a554c49415f4c4f41445f50415448` が設定されていない場合、`/foo/bar:` に設定され、これは `LOAD_PATH` の値 `["/foo/bar", "@", "@v#.#", "@stdlib"]` に展開されます。もし `4d61726b646f776e2e436f64652822222c20224a554c49415f4c4f41445f504154482229_40726566204a554c49415f4c4f41445f50415448` が空文字列に設定されている場合、空の `LOAD_PATH` 配列に展開されます。言い換えれば、空文字列はゼロ要素の配列として解釈され、一要素の空文字列の配列としては解釈されません。この動作は、環境変数を介して空のロードパスを設定できるようにするために選ばれました。デフォルトのロードパスを希望する場合は、環境変数を未設定にするか、値を持たなければならない場合は、文字列 `:` に設定してください。

!!! note
    Windowsでは、パス要素は`；`文字で区切られています。これは、Windowsのほとんどのパスリストでも同様です。


### [`JULIA_DEPOT_PATH`](@id JULIA_DEPOT_PATH)

[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) 環境変数は、グローバルな Julia [`DEPOT_PATH`](@ref) 変数を設定するために使用され、これはパッケージマネージャーや Julia のコード読み込みメカニズムがパッケージレジストリ、インストールされたパッケージ、名前付き環境、リポジトリのクローン、キャッシュされたコンパイル済みパッケージイメージ、設定ファイル、および REPL の履歴ファイルのデフォルトの場所を探す場所を制御します。

Unlike the shell `PATH` variable but similar to [`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH), empty entries in [`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) have special behavior:

  * 最後に、ユーザーデポを*除外して*、`DEPOT_PATH`のデフォルト値に拡張されます。
  * 最初は、ユーザーデポを*含む* `DEPOT_PATH` のデフォルト値に展開されます。

これにより、ユーザーデポの簡単なオーバーライドが可能になり、キャッシュファイルやアーティファクトなど、Juliaにバンドルされているリソースへのアクセスを維持できます。たとえば、ユーザーデポを`/foo/bar`に切り替えるには、末尾に`:`を付けます。

```sh
export JULIA_DEPOT_PATH="/foo/bar:"
```

すべてのパッケージ操作、例えばレジストリのクローンやパッケージのインストールは、現在 `/foo/bar` に書き込まれますが、空のエントリはデフォルトのシステムデポに展開されるため、バンドルされたリソースは引き続き利用可能です。もし本当に `/foo/bar` のデポのみを使用し、バンドルされたリソースを読み込まないようにしたい場合は、環境変数をトレーリングコロンなしで `/foo/bar` に設定してください。

フルデフォルトリストの最後にデポを追加するには、デフォルトユーザーデポを含めて、先頭に `:` を付けてください。

```sh
export JULIA_DEPOT_PATH=":/foo/bar"
```

上記のルールには2つの例外があります。まず、[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH)が空の文字列に設定されている場合、空の`DEPOT_PATH`配列に展開されます。言い換えれば、空の文字列はゼロ要素の配列として解釈され、空の文字列の1要素の配列としては解釈されません。この動作は、環境変数を介して空のデポパスを設定できるようにするために選択されました。

第二に、[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH)にユーザーデポが指定されていない場合、空のエントリはデフォルトのデポに*ユーザーデポを含めて*展開されます。これにより、環境変数が未設定のようにデフォルトのデポを使用することができ、文字列 `:` に設定することができます。

!!! note
    Windowsでは、パス要素は`；`文字で区切られています。これは、Windowsのほとんどのパスリストでも同様です。上記の段落では`：`を`；`に置き換えてください。


!!! note
    [`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) は、juliaを開始する前に定義する必要があります。`startup.jl` で定義するのは、起動プロセスの時点では遅すぎます。その時点では、環境変数からポピュレートされる `DEPOT_PATH` 配列を直接変更することができます。


### [`JULIA_HISTORY`](@id JULIA_HISTORY)

REPLの履歴ファイルの絶対パス `REPL.find_hist_file()`。`$JULIA_HISTORY` が設定されていない場合、`REPL.find_hist_file()` はデフォルトで

```
$(DEPOT_PATH[1])/logs/repl_history.jl
```

### [`JULIA_MAX_NUM_PRECOMPILE_FILES`](@id JULIA_MAX_NUM_PRECOMPILE_FILES)

単一のパッケージの異なるインスタンスをプリコンパイルキャッシュに保存する最大数を設定します（デフォルト = 10）。

### [`JULIA_VERBOSE_LINKING`](@id JULIA_VERBOSE_LINKING)

プリコンパイル中にリンカコマンドが表示されるように設定されている場合は、trueに設定します。

## Pkg.jl

### [`JULIA_CI`](@id JULIA_CI)

`true` に設定されている場合、これはパッケージサーバーに対して、すべてのパッケージ操作がパッケージ使用統計を収集する目的で継続的インテグレーション (CI) システムの一部であることを示します。

### [`JULIA_NUM_PRECOMPILE_TASKS`](@id JULIA_NUM_PRECOMPILE_TASKS)

パッケージを事前コンパイルする際に使用する並列タスクの数。[`Pkg.precompile`](https://pkgdocs.julialang.org/v1/api/#Pkg.precompile)。

### [`JULIA_PKG_DEVDIR`](@id JULIA_PKG_DEVDIR)

[`Pkg.develop`](https://pkgdocs.julialang.org/v1/api/#Pkg.develop)によってパッケージをダウンロードするために使用されるデフォルトディレクトリ。

### [`JULIA_PKG_IGNORE_HASHES`](@id JULIA_PKG_IGNORE_HASHES)

`1`に設定すると、アーティファクト内の不正なハッシュを無視します。これは、ダウンロードの検証を無効にするため、慎重に使用する必要がありますが、異なる種類のファイルシステム間でファイルを移動する際の問題を解決することができます。詳細については、[Pkg.jl issue #2317](https://github.com/JuliaLang/Pkg.jl/issues/2317)を参照してください。

!!! compat "Julia 1.6"
    これはJulia 1.6以上でのみサポートされています。


### [`JULIA_PKG_OFFLINE`](@id JULIA_PKG_OFFLINE)

`true` に設定すると、オフラインモードが有効になります: [`Pkg.offline`](https://pkgdocs.julialang.org/v1/api/#Pkg.offline)。

!!! compat "Julia 1.5"
    Pkgのオフラインモードは、Julia 1.5以降が必要です。


### [`JULIA_PKG_PRECOMPILE_AUTO`](@id JULIA_PKG_PRECOMPILE_AUTO)

`0`に設定すると、マニフェストを変更するパッケージアクションによる自動プリコンパイルが無効になります。[`Pkg.precompile`](https://pkgdocs.julialang.org/v1/api/#Pkg.precompile)。

### [`JULIA_PKG_SERVER`](@id JULIA_PKG_SERVER)

パッケージレジストリのURLを指定します。デフォルトでは、`Pkg`は`https://pkg.julialang.org`を使用してJuliaパッケージを取得します。さらに、PkgServerプロトコルの使用を無効にし、代わりにホスト（GitHub、GitLabなど）から直接パッケージにアクセスするには、次のように設定します: `export JULIA_PKG_SERVER=""`

### [`JULIA_PKG_SERVER_REGISTRY_PREFERENCE`](@id JULIA_PKG_SERVER_REGISTRY_PREFERENCE)

好ましいレジストリのフレーバーを指定します。現在サポートされている値は、`conservative`（デフォルト）で、これはストレージサーバーによって処理されたリソースのみを公開します（したがって、PkgServersから利用可能である確率が高くなります）。一方、`eager`は、ストレージサーバーによって必ずしも処理されていないリソースを持つレジストリを公開します。任意のサーバーからのダウンロードを許可しない制限のあるファイアウォールの背後にいるユーザーは、`eager`フレーバーを使用しないでください。

!!! compat "Julia 1.7"
    これはJulia 1.7以上にのみ影響します。


### [`JULIA_PKG_UNPACK_REGISTRY`](@id JULIA_PKG_UNPACK_REGISTRY)

`true` に設定すると、レジストリを圧縮された tarball として保存するのではなく、展開します。

!!! compat "Julia 1.7"
    これはJulia 1.7以降にのみ影響します。以前のバージョンは常にレジストリを展開します。


### [`JULIA_PKG_USE_CLI_GIT`](@id JULIA_PKG_USE_CLI_GIT)

`true` に設定されている場合、git プロトコルを使用する Pkg 操作は、デフォルトの libgit2 ライブラリの代わりに外部の `git` 実行可能ファイルを使用します。

!!! compat "Julia 1.7"
    `git` 実行可能ファイルの使用は、Julia 1.7 以降でのみサポートされています。


### [`JULIA_PKGRESOLVE_ACCURACY`](@id JULIA_PKGRESOLVE_ACCURACY)

パッケージリゾルバーの精度。これは正の整数である必要があり、デフォルトは `1` です。

### [`JULIA_PKG_PRESERVE_TIERED_INSTALLED`](@id JULIA_PKG_PRESERVE_TIERED_INSTALLED)

デフォルトのパッケージインストール戦略を `Pkg.PRESERVE_TIERED_INSTALLED` に変更して、パッケージマネージャーができるだけ多くの既にインストールされているパッケージのバージョンを保持しながら、パッケージのバージョンをインストールしようとするようにします。

!!! compat "Julia 1.9"
    これはJulia 1.9以上にのみ影響します。


### [`JULIA_PKG_GC_AUTO`](@id JULIA_PKG_GC_AUTO)

`false`に設定すると、パッケージとアーティファクトの自動ガベージコレクションが無効になります。詳細については、[`Pkg.gc`](https://pkgdocs.julialang.org/v1/api/#Pkg.gc)を参照してください。

!!! compat "Julia 1.12"
    この環境変数は、Julia 1.12以降でのみサポートされています。


## Network transport

### [`JULIA_NO_VERIFY_HOSTS`](@id JULIA_NO_VERIFY_HOSTS)

### [`JULIA_SSL_NO_VERIFY_HOSTS`](@id JULIA_SSL_NO_VERIFY_HOSTS)

### [`JULIA_SSH_NO_VERIFY_HOSTS`](@id JULIA_SSH_NO_VERIFY_HOSTS)

### [`JULIA_ALWAYS_VERIFY_HOSTS`](@id JULIA_ALWAYS_VERIFY_HOSTS)

特定のトランスポート層に対して、アイデンティティを確認すべきホストまたは確認すべきでないホストを指定します。詳細は [`NetworkOptions.verify_host`](https://github.com/JuliaLang/NetworkOptions.jl#verify_host) を参照してください。

### [`JULIA_SSL_CA_ROOTS_PATH`](@id JULIA_SSL_CA_ROOTS_PATH)

証明書機関のルートを含むファイルまたはディレクトリを指定してください。See [`NetworkOptions.ca_roots`](https://github.com/JuliaLang/NetworkOptions.jl#ca_roots)

## External applications

### [`JULIA_SHELL`](@id JULIA_SHELL)

Juliaが外部コマンドを実行するために使用するシェルの絶対パス（`Base.repl_cmd()`を介して）。デフォルトは環境変数`$SHELL`で、`$SHELL`が設定されていない場合は`/bin/sh`にフォールバックします。

!!! note
    Windowsでは、この環境変数は無視され、外部コマンドは直接実行されます。


### [`JULIA_EDITOR`](@id JULIA_EDITOR)

`InteractiveUtils.editor()`によって返され、例えば[`InteractiveUtils.edit`](@ref)で使用される、好みのエディタのコマンドを指します。例えば`vim`のように。

`$JULIA_EDITOR` は `$VISUAL` よりも優先され、さらに `$EDITOR` よりも優先されます。これらの環境変数がいずれも設定されていない場合、エディタは Windows および OS X では `open` と見なされ、存在する場合は `/etc/alternatives/editor`、それ以外の場合は `emacs` となります。

WindowsでVisual Studio Codeを使用するには、`$JULIA_EDITOR`を`code.cmd`に設定します。

## Parallelization

### [`JULIA_CPU_THREADS`](@id JULIA_CPU_THREADS)

グローバル変数 [`Base.Sys.CPU_THREADS`](@ref) をオーバーライドし、利用可能な論理CPUコアの数を設定します。

### [`JULIA_WORKER_TIMEOUT`](@id JULIA_WORKER_TIMEOUT)

[`Float64`](@ref) は、`Distributed.worker_timeout()` の値を設定します（デフォルト: `60.0`）。この関数は、ワーカープロセスがマスタープロセスとの接続を確立するまで待機する秒数を示します。

### [`JULIA_NUM_THREADS`](@id JULIA_NUM_THREADS)

符号なし64ビット整数（`uint64_t`）または文字列で、Juliaで利用可能な最大スレッド数を設定します。`$JULIA_NUM_THREADS`が設定されていないか、非正の整数である場合、またはシステムコールを通じてCPUスレッドの数を特定できない場合、スレッド数は`1`に設定されます。

`$JULIA_NUM_THREADS`が`auto`に設定されている場合、スレッドの数はCPUスレッドの数に設定されます。また、`:default`と`:interactive`のサイズを指定するために、カンマ区切りの文字列に設定することもできます。[threadpools](@ref man-threadpools)それぞれ:

```bash
# 5 threads in the :default pool and 2 in the :interactive pool
export JULIA_NUM_THREADS=5,2

# `auto` threads in the :default pool and 1 in the :interactive pool
export JULIA_NUM_THREADS=auto,1
```

!!! note
    `JULIA_NUM_THREADS` は、Juliaを開始する前に定義する必要があります。`startup.jl` で定義するのは、起動プロセスの中では遅すぎます。


!!! compat "Julia 1.5"
    Julia 1.5以降では、スレッドの数を起動時に`-t`/`--threads`コマンドライン引数を使用して指定することもできます。


!!! compat "Julia 1.7"
    `$JULIA_NUM_THREADS`の`auto`値は、Julia 1.7以上が必要です。


!!! compat "Julia 1.9"
    スレッドプールの `x,y` 形式は、Julia 1.9 以上が必要です。


### [`JULIA_THREAD_SLEEP_THRESHOLD`](@id JULIA_THREAD_SLEEP_THRESHOLD)

文字列が大文字小文字を区別せずに部分文字列 `"infinite"` で始まる場合、スピニングスレッドは決してスリープしません。それ以外の場合、`$JULIA_THREAD_SLEEP_THRESHOLD` は符号なし 64 ビット整数（`uint64_t`）として解釈され、スピニングスレッドがスリープすべき時間をナノ秒単位で示します。

### [`JULIA_NUM_GC_THREADS`](@id JULIA_NUM_GC_THREADS)

ガーベジコレクションで使用されるスレッドの数を設定します。指定されていない場合は、ワーカースレッドの数に設定されます。

!!! compat "Julia 1.10"
    環境変数は1.10で追加されました。


### [`JULIA_IMAGE_THREADS`](@id JULIA_IMAGE_THREADS)

このJuliaプロセスでの画像コンパイルに使用されるスレッド数を設定する符号なし32ビット整数です。この変数の値は、モジュールが小さなモジュールである場合は無視されることがあります。指定しない場合、[`JULIA_CPU_THREADS`](@ref JULIA_CPU_THREADS)の値または論理CPUコアの数の半分の小さい方が代わりに使用されます。

### [`JULIA_IMAGE_TIMINGS`](@id JULIA_IMAGE_TIMINGS)

画像コンパイル中に詳細なタイミング情報が印刷されるかどうかを決定するブール値。デフォルトは0です。

### [`JULIA_EXCLUSIVE`](@id JULIA_EXCLUSIVE)

もし `0` 以外の値に設定されている場合、Julia のスレッドポリシーは専用マシンでの実行と一致します：デフォルトのスレッドプール内の各スレッドはアフィニティが設定されています。 [Interactive threads](@ref man-threadpools) はオペレーティングシステムのスケジューラの制御下にあります。

それ以外の場合、Juliaはオペレーティングシステムにスレッドポリシーを処理させます。

## Garbage Collection

### [`JULIA_HEAP_SIZE_HINT`](@id JULIA_HEAP_SIZE_HINT)

`--heap-size-hint=<size>[<unit>]` コマンドラインオプションに相当する環境変数。

メモリ使用量が指定された値を超えた場合にガーベジコレクションを強制します。値はバイト数として指定でき、オプションで以下の単位で指定できます：

```
- B  (bytes)
- K  (kibibytes)
- M  (mebibytes)
- G  (gibibytes)
- T  (tebibytes)
- %  (percentage of physical memory)
```

例えば、`JULIA_HEAP_SIZE_HINT=1G`はガーベジコレクタに1 GBのヒープサイズのヒントを提供します。

## REPL formatting

環境変数は、REPLの出力がターミナルでどのようにフォーマットされるかを決定します。`JULIA_*_COLOR`変数は[ANSI terminal escape sequences](https://en.wikipedia.org/wiki/ANSI_escape_code)に設定する必要があります。Juliaは、同様の機能を持つ高レベルのインターフェースを提供します。[The Julia REPL](@ref)のセクションを参照してください。

### [`JULIA_ERROR_COLOR`](@id JULIA_ERROR_COLOR)

`Base.error_color()` のフォーマット（デフォルト：ライトレッド、`"\033[91m"`）は、ターミナルでエラーが表示される際の色です。

### [`JULIA_WARN_COLOR`](@id JULIA_WARN_COLOR)

`Base.warn_color()` のフォーマット（デフォルト：黄色、`"\033[93m"`）は、警告がターミナルで持つべきものです。

### [`JULIA_INFO_COLOR`](@id JULIA_INFO_COLOR)

`Base.info_color()`（デフォルト：シアン、`"\033[36m"`）は、ターミナルで情報が持つべきフォーマットです。

### [`JULIA_INPUT_COLOR`](@id JULIA_INPUT_COLOR)

`Base.input_color()`（デフォルト：normal, `"\033[0m"`）は、ターミナルで入力が持つべきフォーマットです。

### [`JULIA_ANSWER_COLOR`](@id JULIA_ANSWER_COLOR)

`Base.answer_color()`（デフォルト：normal、`"\033[0m"`）は、ターミナルで出力されるべきフォーマットです。

### [`NO_COLOR`](@id NO_COLOR)

When this variable is present and not an empty string (regardless of its value) then colored text will be disabled on the REPL. Can be overridden with the flag `--color=yes` or with the environment variable [`FORCE_COLOR`](@ref FORCE_COLOR). This environment variable is [commonly recognized by command-line applications](https://no-color.org/).

### [`FORCE_COLOR`](@id FORCE_COLOR)

この変数が存在し、空の文字列でない場合（その値に関係なく）、REPLでカラー付きテキストが有効になります。フラグ `--color=no` で上書きすることができます。この環境変数は [commonly recognized by command-line applications](https://force-color.org/) です。

## System and Package Image Building

### [`JULIA_CPU_TARGET`](@id JULIA_CPU_TARGET)

ターゲットマシンアーキテクチャを変更して、[system](@ref sysimg-multi-versioning) と [package images](@ref pkgimgs-multi-versioning) を（事前）コンパイルします。`JULIA_CPU_TARGET` は、ディスクキャッシュに出力される機械コードイメージ生成にのみ影響します。`--cpu-target` または `-C` とは異なり、[command line option](@ref cli) は、Julia セッション内でのジャストインタイム（JIT）コード生成には影響を与えず、機械コードはメモリにのみ保存されます。

[`JULIA_CPU_TARGET`](@ref JULIA_CPU_TARGET) の有効な値は、`julia -C help` を実行することで取得できます。

[`JULIA_CPU_TARGET`](@ref JULIA_CPU_TARGET)の設定は、異種計算システムにおいて重要です。ここでは、異なるタイプや機能を持つプロセッサが存在する可能性があります。これは、コンポーネントノードが異なるプロセッサを使用しているため、高性能コンピューティング（HPC）クラスターで一般的に見られます。

CPUターゲット文字列は、`；`で区切られた文字列のリストであり、各文字列はCPUまたはアーキテクチャ名で始まり、オプションの機能リストが`,`で区切られて続きます。`generic`または空のCPU名は、ターゲットISAの基本的な必要機能セットを意味し、これは少なくともC/C++ランタイムがコンパイルされているアーキテクチャです。各文字列はLLVMによって解釈されます。

いくつかの特別な機能がサポートされています：

1. `clone_all`

    これにより、ターゲットはsysimg内のすべての関数をクローンする必要があります。負の形（つまり`-clone_all`）で使用されると、特定のターゲットに対してデフォルトで有効になっているフルクローンが無効になります。
2. `base([0-9]*)`

    これは（0ベースの）ベースターゲットインデックスを指定します。ベースターゲットは、現在のターゲットが基づいているターゲットであり、すなわち、クローンされない関数はベースターゲットのバージョンを使用します。このオプションは、ベースターゲットがデフォルトターゲット（0）でない場合、ベースターゲットを完全にクローンする原因となります（それに対して`clone_all`が指定されているかのように）。インデックスは現在のインデックスよりも小さい場合のみ可能です。
3. `opt_size`

    サイズを最適化し、パフォーマンスへの影響を最小限に抑えます。Clang/GCCの `-Os`。
4. `min_size`

    サイズの最適化のみ。Clangの `-Oz`。

## Debugging and profiling

### [`JULIA_DEBUG`](@id JULIA_DEBUG)

ファイルまたはモジュールのデバッグログを有効にするには、[`Logging`](@ref man-logging)を参照してください。

### [`JULIA_PROFILE_PEEK_HEAP_SNAPSHOT`](@id JULIA_PROFILE_PEEK_HEAP_SNAPSHOT)

実行中にプロファイリングピークメカニズムを介してヒープスナップショットの収集を有効にします。[Triggered During Execution](@ref)を参照してください。

### [`JULIA_TIMING_SUBSYSTEMS`](@id JULIA_TIMING_SUBSYSTEMS)

特定のJulia実行のためにゾーンを有効または無効にすることができます。たとえば、変数を `+GC,-INFERENCE` に設定すると、`GC` ゾーンが有効になり、`INFERENCE` ゾーンが無効になります。[Dynamically Enabling and Disabling Zones](@ref) を参照してください。

### [`JULIA_GC_NO_GENERATIONAL`](@id JULIA_GC_NO_GENERATIONAL)

`0`以外の値に設定されている場合、Juliaのガベージコレクタはメモリの「クイックスイープ」を決して実行しません。

!!! note
    この環境変数は、Juliaがガーベジコレクションデバッグでコンパイルされている場合にのみ効果があります（つまり、ビルド構成で`WITH_GC_DEBUG_ENV`が`1`に設定されている場合）。


### [`JULIA_GC_WAIT_FOR_DEBUGGER`](@id JULIA_GC_WAIT_FOR_DEBUGGER)

`0`以外の値に設定されている場合、Juliaのガベージコレクタは、重大なエラーが発生したときに中止するのではなく、デバッガが接続するのを待ちます。

!!! note
    この環境変数は、Juliaがガーベジコレクションデバッグでコンパイルされている場合にのみ効果があります（つまり、ビルド構成で`WITH_GC_DEBUG_ENV`が`1`に設定されている場合）。


### [`ENABLE_JITPROFILING`](@id ENABLE_JITPROFILING)

`0`以外の値に設定すると、コンパイラはジャストインタイム（JIT）プロファイリングのためのイベントリスナーを作成して登録します。

!!! note
    この環境変数は、JuliaがJITプロファイリングサポートでコンパイルされた場合にのみ効果があります。

      * Intelの [VTune™ Amplifier](https://software.intel.com/en-us/vtune) （ビルド構成で `USE_INTEL_JITEVENTS` が `1` に設定されている場合）、または
      * [OProfile](https://oprofile.sourceforge.io/news/) (`USE_OPROFILE_JITEVENTS` をビルド構成で `1` に設定)。
      * [Perf](https://perf.wiki.kernel.org) (`USE_PERF_JITEVENTS`がビルド構成で`1`に設定されています)。この統合はデフォルトで有効になっています。


### [`ENABLE_GDBLISTENER`](@id ENABLE_GDBLISTENER)

`0`以外の値に設定すると、リリースビルドでのJuliaコードのGDB登録が有効になります。Juliaのデバッグビルドでは、これは常に有効です。`-g 2`と一緒に使用することをお勧めします。

### [`JULIA_LLVM_ARGS`](@id JULIA_LLVM_ARGS)

LLVMバックエンドに渡される引数。

### `JULIA_FALLBACK_REPL`

REPL.jlの代わりにフォールバックREPLを強制します。
