# Environment Variables

Juliaは、各オペレーティングシステムの通常の方法で、またはJulia内からポータブルな方法で設定できるいくつかの環境変数を持っています。環境変数[`JULIA_EDITOR`](@ref JULIA_EDITOR)を`vim`に設定したい場合、`ENV["JULIA_EDITOR"] = "vim"`と入力することで（例えば、REPL内で）この変更をケースバイケースで行うことができます。また、ユーザーのホームディレクトリにあるユーザー設定ファイル`~/.julia/config/startup.jl`に同じ内容を追加することで、永続的な効果を得ることができます。同じ環境変数の現在の値は、`ENV["JULIA_EDITOR"]`を評価することで確認できます。

Juliaが使用する環境変数は一般的に`JULIA`で始まります。もし[`InteractiveUtils.versioninfo`](@ref)がキーワード`verbose=true`で呼び出されると、出力には`JULIA`を名前に含む、Juliaに関連する定義済みの環境変数がリストされます。

!!! note
    実行時に環境変数を変更することは避けることが推奨されます。たとえば、`~/.julia/config/startup.jl`内での変更です。

    一つの理由は、[`JULIA_NUM_THREADS`](@ref JULIA_NUM_THREADS)や[`JULIA_PROJECT`](@ref JULIA_PROJECT)のような一部のJulia言語の変数は、Juliaが起動する前に設定する必要があるためです。

    同様に、sysimage内のユーザーモジュールの`__init__()`関数は`startup.jl`の前に実行されるため、`startup.jl`で環境変数を設定するのはユーザーコードにとっては遅すぎるかもしれません。

    さらに、実行時に環境変数を変更すると、無害なコードにデータ競合が発生する可能性があります。

    Bashでは、環境変数は手動で設定することができます。例えば、`export JULIA_NUM_THREADS=4`を実行してからJuliaを起動するか、同じコマンドを`~/.bashrc`または`~/.bash_profile`に追加して、Bashが起動するたびに変数を設定することができます。


## File locations

### [`JULIA_BINDIR`](@id JULIA_BINDIR)

Julia実行可能ファイルを含むディレクトリの絶対パスで、グローバル変数 [`Sys.BINDIR`](@ref) を設定します。 `$JULIA_BINDIR` が設定されていない場合、Juliaは実行時に `Sys.BINDIR` の値を決定します。

実行可能ファイル自体はそのうちの一つです。

```
$JULIA_BINDIR/julia
$JULIA_BINDIR/julia-debug
```

デフォルトで。

グローバル変数 `Base.DATAROOTDIR` は、`Sys.BINDIR` から Julia に関連付けられたデータディレクトリへの相対パスを決定します。次に、そのパス

```
$JULIA_BINDIR/$DATAROOTDIR/julia/base
```

ソースファイルを最初に検索するディレクトリを決定します（`Base.find_source_file()`を介して）。

同様に、グローバル変数 `Base.SYSCONFDIR` は設定ファイルディレクトリへの相対パスを決定します。次に、Juliaは `startup.jl` ファイルを探します。

```
$JULIA_BINDIR/$SYSCONFDIR/julia/startup.jl
$JULIA_BINDIR/../etc/julia/startup.jl
```

デフォルトでは（`Base.load_julia_startup()`を介して）。

例えば、`/bin/julia` にある Julia 実行可能ファイル、`../share` の `DATAROOTDIR`、および `../etc` の `SYSCONFDIR` を持つ Linux インストールでは、[`JULIA_BINDIR`](@ref JULIA_BINDIR) が `/bin` に設定され、ソースファイルの検索パスは次のようになります。

```
/share/julia/base
```

およびグローバル設定検索パスの

```
/etc/julia/startup.jl
```

### [`JULIA_PROJECT`](@id JULIA_PROJECT)

初期アクティブプロジェクトを示すディレクトリパス。この環境変数を設定することは、`--project` スタートアップオプションを指定するのと同じ効果がありますが、`--project` の方が優先されます。変数が `@.` に設定されている場合（末尾のドットに注意）、Julia は現在のディレクトリとその親ディレクトリから `Project.toml` または `JuliaProject.toml` ファイルを含むプロジェクトディレクトリを探します。詳細については、[Code Loading](@ref code-loading) に関する章を参照してください。

!!! note
    [`JULIA_PROJECT`](@ref JULIA_PROJECT) は、juliaを開始する前に定義する必要があります。 `startup.jl` で定義するのは、スタートアッププロセスの時期としては遅すぎます。


### [`JULIA_LOAD_PATH`](@id JULIA_LOAD_PATH)

[`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) 環境変数は、グローバルな Julia [`LOAD_PATH`](@ref) 変数を設定するために使用され、どのパッケージが `import` および `using` を介してロードできるかを決定します（[Code Loading](@ref code-loading) を参照）。

シェルの `PATH` 変数とは異なり、[`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) の空のエントリは、`LOAD_PATH` を設定する際にデフォルト値 `["@", "@v#.#", "@stdlib"]` に展開されます。これにより、`4d61726b646f776e2e436f64652822222c20224a554c49415f4c4f41445f504154482229_40726566204a554c49415f4c4f41445f50415448` がすでに設定されているかどうかに関係なく、シェルスクリプトでロードパスの値を簡単に追加、先頭に追加などができます。たとえば、ディレクトリ `/foo/bar` を `LOAD_PATH` の先頭に追加するには、次のようにします。

```sh
export JULIA_LOAD_PATH="/foo/bar:$JULIA_LOAD_PATH"
```

もし [`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) 環境変数がすでに設定されている場合、その古い値の前に `/foo/bar` が追加されます。一方、`4d61726b646f776e2e436f64652822222c20224a554c49415f4c4f41445f504154482229_40726566204a554c49415f4c4f41445f50415448` が設定されていない場合、`/foo/bar:` に設定され、これにより `LOAD_PATH` の値は `["/foo/bar", "@", "@v#.#", "@stdlib"]` になります。もし `4d61726b646f776e2e436f64652822222c20224a554c49415f4c4f41445f504154482229_40726566204a554c49415f4c4f41445f50415448` が空文字列に設定されている場合、空の `LOAD_PATH` 配列に展開されます。言い換えれば、空文字列はゼロ要素の配列として解釈され、一要素の空文字列の配列としては解釈されません。この動作は、環境変数を介して空のロードパスを設定できるようにするために選ばれました。デフォルトのロードパスを使用したい場合は、環境変数を解除するか、値を持たなければならない場合は、文字列 `:` に設定してください。

!!! note
    Windowsでは、パス要素は`；`文字で区切られています。これは、Windowsのほとんどのパスリストでも同様です。上記の段落では`：`を`；`に置き換えてください。


### [`JULIA_DEPOT_PATH`](@id JULIA_DEPOT_PATH)

[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) 環境変数は、グローバルな Julia [`DEPOT_PATH`](@ref) 変数を設定するために使用されます。この変数は、パッケージマネージャーや Julia のコード読み込みメカニズムが、パッケージレジストリ、インストールされたパッケージ、名前付き環境、リポジトリのクローン、キャッシュされたコンパイル済みパッケージイメージ、設定ファイル、および REPL の履歴ファイルのデフォルトの場所を探す場所を制御します。

シェルの `PATH` 変数とは異なり、しかし [`JULIA_LOAD_PATH`](@ref JULIA_LOAD_PATH) に似て、[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) の空のエントリには特別な動作があります：

  * 最後に、ユーザーデポを*除外して*、`DEPOT_PATH`のデフォルト値に拡張されます。
  * 最初は、ユーザーデポを*含む* `DEPOT_PATH` のデフォルト値に展開されます。

これにより、ユーザーデポの簡単なオーバーライドが可能になり、キャッシュファイルやアーティファクトなど、Juliaにバンドルされているリソースへのアクセスを維持できます。たとえば、ユーザーデポを`/foo/bar`に切り替えるには、末尾に`:`を付けます。

```sh
export JULIA_DEPOT_PATH="/foo/bar:"
```

すべてのパッケージ操作、例えばレジストリのクローンやパッケージのインストールは、現在 `/foo/bar` に書き込まれますが、空のエントリはデフォルトのシステムデポに展開されるため、バンドルされたリソースは引き続き利用可能です。もし本当に `/foo/bar` のデポのみを使用し、バンドルされたリソースを読み込まないようにしたい場合は、末尾のコロンなしで環境変数を `/foo/bar` に設定してください。

デフォルトのユーザーデポを含むフルデフォルトリストの最後にデポを追加するには、先頭に `:` を付けます。

```sh
export JULIA_DEPOT_PATH=":/foo/bar"
```

上記のルールには2つの例外があります。まず、[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) が空の文字列に設定されている場合、空の `DEPOT_PATH` 配列に展開されます。言い換えれば、空の文字列はゼロ要素の配列として解釈され、空の文字列の1要素の配列としては解釈されません。この動作は、環境変数を介して空のデポパスを設定できるようにするために選択されました。

第二に、[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH)でユーザーデポが指定されていない場合、空のエントリはデフォルトのデポに拡張され、*ユーザーデポを含む*ようになります。これにより、環境変数が未設定のようにデフォルトのデポを使用することが可能になり、文字列 `:` に設定することができます。

!!! note
    Windowsでは、パス要素は`；`文字で区切られています。これは、Windowsのほとんどのパスリストでも同様です。


!!! note
    [`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) は、juliaを開始する前に定義する必要があります。`startup.jl` で定義するのは、スタートアッププロセスの時点では遅すぎます。その時点では、環境変数からポピュレートされる `DEPOT_PATH` 配列を直接修正することができます。


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

パッケージを事前コンパイルする際に使用する並列タスクの数。[`Pkg.precompile`](https://pkgdocs.julialang.org/v1/api/#Pkg.precompile)を参照してください。

### [`JULIA_PKG_DEVDIR`](@id JULIA_PKG_DEVDIR)

[`Pkg.develop`](https://pkgdocs.julialang.org/v1/api/#Pkg.develop) がパッケージをダウンロードするために使用するデフォルトディレクトリです。

### [`JULIA_PKG_IGNORE_HASHES`](@id JULIA_PKG_IGNORE_HASHES)

`1`に設定すると、アーティファクト内の不正なハッシュを無視します。これは、ダウンロードの検証を無効にするため、慎重に使用する必要がありますが、異なる種類のファイルシステム間でファイルを移動する際の問題を解決することができます。詳細については、[Pkg.jl issue #2317](https://github.com/JuliaLang/Pkg.jl/issues/2317)を参照してください。

!!! compat "Julia 1.6"
    これはJulia 1.6以上でのみサポートされています。


### [`JULIA_PKG_OFFLINE`](@id JULIA_PKG_OFFLINE)

`true` に設定すると、オフラインモードが有効になります: [`Pkg.offline`](https://pkgdocs.julialang.org/v1/api/#Pkg.offline) を参照してください。

!!! compat "Julia 1.5"
    Pkgのオフラインモードは、Julia 1.5以降が必要です。


### [`JULIA_PKG_PRECOMPILE_AUTO`](@id JULIA_PKG_PRECOMPILE_AUTO)

`0`に設定すると、マニフェストを変更するパッケージアクションによる自動プリコンパイルが無効になります。詳細は [`Pkg.precompile`](https://pkgdocs.julialang.org/v1/api/#Pkg.precompile) を参照してください。

### [`JULIA_PKG_SERVER`](@id JULIA_PKG_SERVER)

パッケージレジストリのURLを指定します。デフォルトでは、`Pkg`はJuliaパッケージを取得するために`https://pkg.julialang.org`を使用します。さらに、PkgServerプロトコルの使用を無効にし、代わりにホスト（GitHub、GitLabなど）から直接パッケージにアクセスするには、次のように設定します: `export JULIA_PKG_SERVER=""`

### [`JULIA_PKG_SERVER_REGISTRY_PREFERENCE`](@id JULIA_PKG_SERVER_REGISTRY_PREFERENCE)

好ましいレジストリのフレーバーを指定します。現在サポートされている値は、`conservative`（デフォルト）で、これはストレージサーバーによって処理されたリソースのみを公開します（したがって、PkgServersから利用可能である可能性が高くなります）。一方、`eager`は、ストレージサーバーによって必ずしも処理されていないリソースを持つレジストリを公開します。任意のサーバーからのダウンロードを許可しない制限のあるファイアウォールの背後にいるユーザーは、`eager`フレーバーを使用しないでください。

!!! compat "Julia 1.7"
    これはJulia 1.7以上にのみ影響します。


### [`JULIA_PKG_UNPACK_REGISTRY`](@id JULIA_PKG_UNPACK_REGISTRY)

`true` に設定すると、レジストリを圧縮された tarball として保存するのではなく、展開します。

!!! compat "Julia 1.7"
    これはJulia 1.7以降にのみ影響します。以前のバージョンでは常にレジストリが展開されます。


### [`JULIA_PKG_USE_CLI_GIT`](@id JULIA_PKG_USE_CLI_GIT)

`true` に設定されている場合、git プロトコルを使用する Pkg 操作は、デフォルトの libgit2 ライブラリの代わりに外部の `git` 実行可能ファイルを使用します。

!!! compat "Julia 1.7"
    `git` 実行可能ファイルの使用は、Julia 1.7 以降でのみサポートされています。


### [`JULIA_PKGRESOLVE_ACCURACY`](@id JULIA_PKGRESOLVE_ACCURACY)

パッケージリゾルバーの精度。これは正の整数である必要があり、デフォルトは `1` です。

### [`JULIA_PKG_PRESERVE_TIERED_INSTALLED`](@id JULIA_PKG_PRESERVE_TIERED_INSTALLED)

デフォルトのパッケージインストール戦略を `Pkg.PRESERVE_TIERED_INSTALLED` に変更して、パッケージマネージャーができるだけ多くの既にインストールされているパッケージのバージョンを保持しながら、パッケージのバージョンをインストールしようとするようにします。

!!! compat "Julia 1.9"
    これはJulia 1.9以降にのみ影響します。


## Network transport

### [`JULIA_NO_VERIFY_HOSTS`](@id JULIA_NO_VERIFY_HOSTS)

### [`JULIA_SSL_NO_VERIFY_HOSTS`](@id JULIA_SSL_NO_VERIFY_HOSTS)

### [`JULIA_SSH_NO_VERIFY_HOSTS`](@id JULIA_SSH_NO_VERIFY_HOSTS)

### [`JULIA_ALWAYS_VERIFY_HOSTS`](@id JULIA_ALWAYS_VERIFY_HOSTS)

特定のトランスポート層に対して、アイデンティティを確認すべきホストまたは確認すべきでないホストを指定します。詳細は [`NetworkOptions.verify_host`](https://github.com/JuliaLang/NetworkOptions.jl#verify_host) を参照してください。

### [`JULIA_SSL_CA_ROOTS_PATH`](@id JULIA_SSL_CA_ROOTS_PATH)

証明書認証局のルートを含むファイルまたはディレクトリを指定してください。次を参照してください [`NetworkOptions.ca_roots`](https://github.com/JuliaLang/NetworkOptions.jl#ca_roots)

## External applications

### [`JULIA_SHELL`](@id JULIA_SHELL)

Juliaが外部コマンドを実行するために使用するシェルの絶対パス（`Base.repl_cmd()`を介して）。デフォルトは環境変数`$SHELL`で、`$SHELL`が設定されていない場合は`/bin/sh`にフォールバックします。

!!! note
    Windowsでは、この環境変数は無視され、外部コマンドは直接実行されます。


### [`JULIA_EDITOR`](@id JULIA_EDITOR)

`InteractiveUtils.editor()` によって返されるエディタは、例えば [`InteractiveUtils.edit`](@ref) で使用され、好みのエディタのコマンドを参照します。例えば `vim` です。

`$JULIA_EDITOR` は `$VISUAL` よりも優先され、さらに `$EDITOR` よりも優先されます。これらの環境変数がいずれも設定されていない場合、エディタは Windows および OS X では `open` と見なされ、存在する場合は `/etc/alternatives/editor`、それ以外の場合は `emacs` となります。

WindowsでVisual Studio Codeを使用するには、`$JULIA_EDITOR`を`code.cmd`に設定します。

## Parallelization

### [`JULIA_CPU_THREADS`](@id JULIA_CPU_THREADS)

グローバル変数 [`Base.Sys.CPU_THREADS`](@ref) をオーバーライドし、利用可能な論理CPUコアの数を設定します。

### [`JULIA_WORKER_TIMEOUT`](@id JULIA_WORKER_TIMEOUT)

[`Float64`](@ref) は、`Distributed.worker_timeout()` の値を設定します（デフォルト: `60.0`）。この関数は、ワーカープロセスがマスタープロセスとの接続を確立するまで待機する秒数を示します。

### [`JULIA_NUM_THREADS`](@id JULIA_NUM_THREADS)

符号なし64ビット整数（`uint64_t`）で、Juliaに利用可能なスレッドの最大数を設定します。 `$JULIA_NUM_THREADS` が正の値でない場合、または設定されていない場合、またはシステムコールを通じてCPUスレッドの数を特定できない場合、スレッドの数は `1` に設定されます。

`$JULIA_NUM_THREADS`が`auto`に設定されている場合、スレッドの数はCPUスレッドの数に設定されます。

!!! note
    `JULIA_NUM_THREADS` は、juliaを開始する前に定義する必要があります。`startup.jl` で定義するのは、起動プロセスの中では遅すぎます。


!!! compat "Julia 1.5"
    Julia 1.5以降では、起動時に`-t`/`--threads`コマンドライン引数を使用してスレッドの数を指定することもできます。


!!! compat "Julia 1.7"
    `$JULIA_NUM_THREADS` の `auto` 値は、Julia 1.7 以上が必要です。


### [`JULIA_THREAD_SLEEP_THRESHOLD`](@id JULIA_THREAD_SLEEP_THRESHOLD)

文字列が大文字小文字を区別せずに部分文字列 `"infinite"` で始まる場合、スピニングスレッドは決してスリープしません。それ以外の場合、`$JULIA_THREAD_SLEEP_THRESHOLD` は符号なし 64 ビット整数（`uint64_t`）として解釈され、スピニングスレッドがスリープすべき時間をナノ秒単位で示します。

### [`JULIA_NUM_GC_THREADS`](@id JULIA_NUM_GC_THREADS)

ガーベジコレクションで使用されるスレッドの数を設定します。指定されていない場合は、ワーカースレッドの数の半分に設定されます。

!!! compat "Julia 1.10"
    環境変数は1.10で追加されました。


### [`JULIA_IMAGE_THREADS`](@id JULIA_IMAGE_THREADS)

このJuliaプロセスでの画像コンパイルに使用されるスレッド数を設定する符号なし32ビット整数です。この変数の値は、モジュールが小さなモジュールである場合は無視されることがあります。指定しない場合、[`JULIA_CPU_THREADS`](@ref JULIA_CPU_THREADS)の値または論理CPUコアの数の半分のうち小さい方が代わりに使用されます。

### [`JULIA_IMAGE_TIMINGS`](@id JULIA_IMAGE_TIMINGS)

画像コンパイル中に詳細なタイミング情報が印刷されるかどうかを決定するブール値。デフォルトは0です。

### [`JULIA_EXCLUSIVE`](@id JULIA_EXCLUSIVE)

もし `0` 以外の値に設定されている場合、Julia のスレッドポリシーは専用マシンでの実行と一致します：マスタースレッドはプロセッサ 0 にあり、スレッドはアフィニティが設定されています。それ以外の場合、Julia はオペレーティングシステムにスレッドポリシーの管理を任せます。

## REPL formatting

REPLの出力がターミナルでどのようにフォーマットされるかを決定する環境変数。一般的に、これらの変数は[ANSI terminal escape sequences](https://en.wikipedia.org/wiki/ANSI_escape_code)に設定する必要があります。Juliaは同様の機能を持つ高レベルのインターフェースを提供しています。[The Julia REPL](@ref)のセクションを参照してください。

### [`JULIA_ERROR_COLOR`](@id JULIA_ERROR_COLOR)

`Base.error_color()`（デフォルト：ライトレッド、`"\033[91m"`）は、ターミナルでエラーが持つべきフォーマットです。

### [`JULIA_WARN_COLOR`](@id JULIA_WARN_COLOR)

警告が端末で持つべきフォーマット `Base.warn_color()`（デフォルト：黄色、`"\033[93m"`）。

### [`JULIA_INFO_COLOR`](@id JULIA_INFO_COLOR)

`Base.info_color()`（デフォルト：シアン、`"\033[36m"`）は、ターミナルでの情報が持つべきフォーマットです。

### [`JULIA_INPUT_COLOR`](@id JULIA_INPUT_COLOR)

`Base.input_color()`（デフォルト：normal, `"\033[0m"`）は、ターミナルで入力が持つべきフォーマットです。

### [`JULIA_ANSWER_COLOR`](@id JULIA_ANSWER_COLOR)

`Base.answer_color()`（デフォルト：通常、`"\033[0m"`）は、ターミナルで出力されるべきフォーマットです。

## System and Package Image Building

### [`JULIA_CPU_TARGET`](@id JULIA_CPU_TARGET)

ターゲットマシンアーキテクチャを変更して、[system](@ref sysimg-multi-versioning) と [package images](@ref pkgimgs-multi-versioning) を（事前）コンパイルします。 `JULIA_CPU_TARGET` は、ディスクキャッシュに出力される機械コードイメージ生成にのみ影響します。 `--cpu-target` または `-C` とは異なり、[command line option](@ref cli) は、Juliaセッション内でのJITコード生成には影響を与えず、機械コードはメモリにのみ保存されます。

[`JULIA_CPU_TARGET`](@ref JULIA_CPU_TARGET)の有効な値は、`julia -C help`を実行することで取得できます。

設定 [`JULIA_CPU_TARGET`](@ref JULIA_CPU_TARGET) は、異種計算システムにおいて重要です。ここでは、異なるタイプや機能を持つプロセッサが存在する可能性があります。これは、コンポーネントノードが異なるプロセッサを使用しているため、高性能計算（HPC）クラスターで一般的に見られます。

CPUターゲット文字列は、`；`で区切られた文字列のリストであり、各文字列はCPUまたはアーキテクチャ名で始まり、オプションの機能リストが`,`で区切られています。`generic`または空のCPU名は、C/C++ランタイムがコンパイルされているアーキテクチャを少なくとも含むターゲットISAの基本的な必須機能セットを意味します。各文字列はLLVMによって解釈されます。

いくつかの特別な機能がサポートされています：

1. `clone_all`

    これは、ターゲットがsysimg内のすべての関数をクローンすることを強制します。負の形（つまり、`-clone_all`）で使用されると、特定のターゲットに対してデフォルトで有効になっているフルクローンを無効にします。
2. `base([0-9]*)`

    これは（0ベースの）ベースターゲットインデックスを指定します。ベースターゲットは、現在のターゲットが基づいているターゲットであり、すなわち、クローンされない関数はベースターゲットのバージョンを使用します。このオプションは、デフォルトターゲット（0）でない場合、ベースターゲットを完全にクローンする原因となります（それに対して`clone_all`が指定されたかのように）。インデックスは現在のインデックスよりも小さい必要があります。
3. `opt_size`

    サイズを最適化し、パフォーマンスへの影響を最小限に抑えます。Clang/GCCの `-Os`。
4. `最小サイズ`

    サイズの最適化のみ。Clangの `-Oz`。

## Debugging and profiling

### [`JULIA_DEBUG`](@id JULIA_DEBUG)

ファイルまたはモジュールのデバッグログを有効にするには、[`Logging`](@ref man-logging)を参照してください。

### [`JULIA_PROFILE_PEEK_HEAP_SNAPSHOT`](@id JULIA_PROFILE_PEEK_HEAP_SNAPSHOT)

実行中にプロファイリングピークメカニズムを介してヒープスナップショットの収集を有効にします。[Triggered During Execution](@ref)を参照してください。

### [`JULIA_TIMING_SUBSYSTEMS`](@id JULIA_TIMING_SUBSYSTEMS)

特定のJulia実行のためにゾーンを有効または無効にすることができます。たとえば、変数を `+GC,-INFERENCE` に設定すると、`GC` ゾーンが有効になり、`INFERENCE` ゾーンが無効になります。[Dynamically Enabling and Disabling Zones](@ref) を参照してください。

### [`JULIA_GC_ALLOC_POOL`](@id JULIA_GC_ALLOC_POOL)

### [`JULIA_GC_ALLOC_OTHER`](@id JULIA_GC_ALLOC_OTHER)

### [`JULIA_GC_ALLOC_PRINT`](@id JULIA_GC_ALLOC_PRINT)

設定されている場合、これらの環境変数は、オプションで文字 `'r'` で始まる文字列を受け取り、その後にコロンで区切られた3つの符号付き64ビット整数（`int64_t`）の文字列補間が続きます。この整数の三つ組 `a:b:c` は、算術数列 `a`、`a + b`、`a + 2*b`、... `c` を表します。

  * `jl_gc_pool_alloc()`が呼び出されたのが`n`回目であり、`n`が`$JULIA_GC_ALLOC_POOL`で表される算術数列に属する場合、ガーベジコレクションが強制されます。
  * `maybe_collect()`が呼ばれたのが`n`回目であり、`n`が`$JULIA_GC_ALLOC_OTHER`で表される算術数列に属する場合、ガーベジコレクションが強制されます。
  * `jl_gc_collect()`が呼び出されたのが`n`回目であり、`n`が`$JULIA_GC_ALLOC_PRINT`で表される算術数列に属する場合、`jl_gc_pool_alloc()`および`maybe_collect()`への呼び出し回数が印刷されます。

環境変数の値が文字 `'r'` で始まる場合、ガーベジコレクションイベントの間隔はランダム化されます。

!!! note
    これらの環境変数は、Juliaがガベージコレクションデバッグでコンパイルされている場合にのみ効果があります（つまり、ビルド構成で`WITH_GC_DEBUG_ENV`が`1`に設定されている場合）。


### [`JULIA_GC_NO_GENERATIONAL`](@id JULIA_GC_NO_GENERATIONAL)

`0`以外の値に設定されている場合、Juliaのガベージコレクタはメモリの「クイックスイープ」を決して実行しません。

!!! note
    この環境変数は、Juliaがガーベジコレクションデバッグでコンパイルされている場合にのみ効果があります（つまり、ビルド構成で`WITH_GC_DEBUG_ENV`が`1`に設定されている場合）。


### [`JULIA_GC_WAIT_FOR_DEBUGGER`](@id JULIA_GC_WAIT_FOR_DEBUGGER)

もし `0` 以外の値に設定されている場合、Julia のガベージコレクタは、重大なエラーが発生したときに中止するのではなく、デバッガが接続するのを待ちます。

!!! note
    この環境変数は、Juliaがガーベジコレクションデバッグでコンパイルされている場合にのみ効果があります（つまり、ビルド構成で`WITH_GC_DEBUG_ENV`が`1`に設定されている場合）。


### [`ENABLE_JITPROFILING`](@id ENABLE_JITPROFILING)

`0`以外の値に設定されている場合、コンパイラはジャストインタイム（JIT）プロファイリングのためのイベントリスナーを作成し、登録します。

!!! note
    この環境変数は、JuliaがJITプロファイリングサポートでコンパイルされた場合にのみ効果があります。

      * インテルの [VTune™ Amplifier](https://software.intel.com/en-us/vtune) （ビルド構成で `USE_INTEL_JITEVENTS` が `1` に設定されている場合）、または
      * [OProfile](https://oprofile.sourceforge.io/news/)（ビルド構成で `USE_OPROFILE_JITEVENTS` が `1` に設定されています）。
      * [Perf](https://perf.wiki.kernel.org)（ビルド構成で`USE_PERF_JITEVENTS`が`1`に設定されています）。この統合はデフォルトで有効になっています。


### [`ENABLE_GDBLISTENER`](@id ENABLE_GDBLISTENER)

`0`以外の値に設定すると、リリースビルドでのJuliaコードのGDB登録が有効になります。Juliaのデバッグビルドでは、これは常に有効です。`-g 2`と一緒に使用することをお勧めします。

### [`JULIA_LLVM_ARGS`](@id JULIA_LLVM_ARGS)

LLVMバックエンドに渡される引数。

### `JULIA_FALLBACK_REPL`

REPL.jlの代わりにフォールバックREPLを強制します。
