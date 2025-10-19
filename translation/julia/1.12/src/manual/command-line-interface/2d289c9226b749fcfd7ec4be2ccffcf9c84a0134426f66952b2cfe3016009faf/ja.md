# [Command-line Interface](@id cli)

## Using arguments inside scripts

スクリプトを `julia` を使って実行する際に、スクリプトに追加の引数を渡すことができます：

```
$ julia script.jl arg1 arg2...
```

これらの追加のコマンドライン引数は、グローバル定数 `ARGS` に渡されます。スクリプト自体の名前は、グローバル `PROGRAM_FILE` として渡されます。コマンドラインで `-e` オプションを使用してJulia式が与えられた場合（以下の `julia` ヘルプ出力を参照）、`ARGS` も設定されますが、`PROGRAM_FILE` は空になります。たとえば、スクリプトに与えられた引数を単に印刷するには、次のようにできます：

```
$ julia -e 'println(PROGRAM_FILE); for x in ARGS; println(x); end' foo bar

foo
bar
```

そのコードをスクリプトに入れて実行することもできます：

```
$ echo 'println(PROGRAM_FILE); for x in ARGS; println(x); end' > script.jl
$ julia script.jl foo bar
script.jl
foo
bar
```

`--` デリミタは、スクリプトファイル用のコマンドライン引数と、Julia用の引数を区別するために使用できます:

```
$ julia --color=yes -O -- script.jl arg1 arg2..
```

詳細な情報については [Scripting](@ref man-scripting) を参照してください。

## The `Main.main` entry point

Julia 1.11 以降、`Base` はマクロ `@main` をエクスポートします。このマクロはシンボル `main` に展開されますが、スクリプトや式の実行が終了すると、`julia` は `Main.main(Base.ARGS)` を実行しようとします。これは、`Main.main` という関数が定義されており、この動作が `@main` マクロを使用することで選択された場合に限ります。

この機能は、コンパイルされたワークフローとインタラクティブなワークフローの統合を支援することを目的としています。コンパイルされたワークフローでは、`main` 関数を定義するコードの読み込みが、呼び出しから空間的および時間的に分離される場合があります。しかし、インタラクティブなワークフローでは、評価されたスクリプトまたは式の最後で `exit(main(ARGS))` を明示的に呼び出すのと同等の動作になります。

!!! compat "Julia 1.11"
    特別なエントリーポイント `Main.main` は Julia 1.11 で追加されました。以前の Julia バージョンとの互換性のために、スクリプトの最後に明示的に `@isdefined(var"@main") ? (@main) : exit(main(ARGS))` を追加してください。


この機能を実際に見るために、次の定義を考えてみてください。これは、`main`への明示的な呼び出しがなくても、print関数を実行します。

```
$ julia -e '(@main)(args) = println("Hello World!")'
Hello World!
$
```

`Main`モジュールの`main`バインディングのみがこの動作を持ち、定義モジュール内でマクロ`@main`が使用された場合に限ります。

例えば、`main`の代わりに`hello`を使用しても、`hello`関数は実行されません:

```
$ julia -e 'hello(args) = println("Hello World!")'
$
```

そして、`main`の単純な定義もそうではありません：

```
$ julia -e 'main(args) = println("Hello World!")'
$
```

ただし、オプトインは定義時に発生する必要はありません：

```
$ julia -e 'main(args) = println("Hello World!"); @main'
Hello World!
$
```

`main` バインディングはパッケージからインポートすることができます。*hello world* パッケージは次のように定義されます。

```
module Hello

export main
(@main)(args) = println("Hello from the package!")

end
```

使用される場合があります：

```
$ julia -e 'using Hello'
Hello from the package!
$ julia -e 'import Hello' # N.B.: Execution depends on the binding not whether the package is loaded
$
```

ただし、現在のベストプラクティスの推奨事項は、アプリケーションコードと再利用可能なライブラリコードを同じパッケージに混在させないことです。ヘルパーアプリケーションは、別のパッケージとして配布するか、パッケージの `bin` フォルダー内にある別の `main` エントリポイントを持つスクリプトとして配布することができます。

## Parallel mode

Juliaは、`-p`または`--machine-file`オプションを使用して並列モードで起動できます。`-p n`は追加の`n`ワーカープロセスを起動し、`--machine-file file`はファイル`file`の各行に対してワーカーを起動します。ファイル`file`に定義されたマシンは、パスワードなしの`ssh`ログインでアクセス可能であり、Juliaは現在のホストと同じ場所にインストールされている必要があります。各マシンの定義は、`[count*][user@]host[:port] [bind_addr[:port]]`の形式を取ります。`user`は現在のユーザーにデフォルト設定され、`port`は標準のsshポートに設定されます。`count`はノード上で生成するワーカーの数で、デフォルトは1です。オプションの`bind-to bind_addr[:port]`は、他のワーカーがこのワーカーに接続するために使用するIPアドレスとポートを指定します。

## Startup file

Juliaを実行するたびに実行したいコードがある場合は、それを`~/.julia/config/startup.jl`に置くことができます：

```
$ echo 'println("Greetings! 你好! 안녕하세요?")' > ~/.julia/config/startup.jl
$ julia
Greetings! 你好! 안녕하세요?

...
```

最初にJuliaを実行した後、`~/.julia`ディレクトリが作成されるはずですが、使用する場合は`~/.julia/config`フォルダと`~/.julia/config/startup.jl`ファイルを作成する必要があるかもしれません。

[The Julia REPL](@ref) でのみスタートアップコードを実行し（例えば、`julia` がスクリプトで実行されるときには実行しない）、`startup.jl` に [`atreplinit`](@ref) を使用します：

```julia
atreplinit() do repl
    # ...
end
```

## [Command-line switches for Julia](@id command-line-interface)

Juliaコードを実行する方法はいくつかあり、`perl`や`ruby`プログラムで利用可能なオプションに似たものがあります：

```
julia [switches] -- [programfile] [args...]
```

次のは、juliaを起動する際に利用可能なコマンドラインスイッチの完全なリストです（'*'はデフォルト値を示します。'($)'でマークされた設定は、パッケージの事前コンパイルをトリガーする可能性があります）：

| Switch                                            | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
|:------------------------------------------------- |:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `-v`, `--version`                                 | Display version information                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `-h`, `--help`                                    | Print command-line options (this message)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `--help-hidden`                                   | Print uncommon options not shown by `-h`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| `--project[={<dir>\|@temp\|@.}]`                  | Set `<dir>` as the active project/environment. Or, create a temporary environment with `@temp`. The default `@.` option will search through parent directories until a `Project.toml` or `JuliaProject.toml` file is found.                                                                                                                                                                                                                                                                                                                                   |
| `-J`, `--sysimage <file>`                         | Start up with the given system image file                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `-H`, `--home <dir>`                              | Set location of `julia` executable                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `--startup-file={yes*\|no}`                       | Load `JULIA_DEPOT_PATH/config/startup.jl`; if [`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) environment variable is unset, load `~/.julia/config/startup.jl`                                                                                                                                                                                                                                                                                                                                                                                                    |
| `--handle-signals={yes*\|no}`                     | Enable or disable Julia's default signal handlers                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `--sysimage-native-code={yes*\|no}`               | Use native code from system image if available                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `--compiled-modules={yes*\|no\|existing\|strict}` | Enable or disable incremental precompilation of modules. The `existing` option allows use of existing compiled modules that were previously precompiled, but disallows creation of new precompile files. The `strict` option is similar, but will error if no precompile file is found.                                                                                                                                                                                                                                                                       |
| `--pkgimages={yes*\|no\|existing}`                | Enable or disable usage of native code caching in the form of pkgimages. The `existing` option allows use of existing pkgimages but disallows creation of new ones                                                                                                                                                                                                                                                                                                                                                                                            |
| `-e`, `--eval <expr>`                             | Evaluate `<expr>`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `-E`, `--print <expr>`                            | Evaluate `<expr>` and display the result                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| `-m`, `--module <Package> [args]`                 | Run entry point of `Package` (`@main` function) with `args'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `-L`, `--load <file>`                             | Load `<file>` immediately on all processors                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `-t`, `--threads {auto\|N[,auto\|M]}`             | Enable N[+M] threads; N threads are assigned to the `default` threadpool, and if M is specified, M threads are assigned to the `interactive` threadpool; `auto` tries to infer a useful default number of threads to use but the exact behavior might change in the future. Currently sets N to the number of CPUs assigned to this Julia process based on the OS-specific affinity assignment interface if supported (Linux and Windows) or to the number of CPU threads if not supported (MacOS) or if process affinity is not configured, and sets M to 1. |
| `--gcthreads=N[,M]`                               | Use N threads for the mark phase of GC and M (0 or 1) threads for the concurrent sweeping phase of GC. N is set to the number of compute threads and M is set to 0 if unspecified. See [Memory Management and Garbage Collection](@ref man-memory-management) for more details.                                                                                                                                                                                                                                                                               |
| `-p`, `--procs {N\|auto}`                         | Integer value N launches N additional local worker processes; `auto` launches as many workers as the number of local CPU threads (logical cores)                                                                                                                                                                                                                                                                                                                                                                                                              |
| `--machine-file <file>`                           | Run processes on hosts listed in `<file>`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `-i`, `--interactive`                             | Interactive mode; REPL runs and `isinteractive()` is true                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `-q`, `--quiet`                                   | Quiet startup: no banner, suppress REPL warnings                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `--banner={yes\|no\|short\|auto*}`                | Enable or disable startup banner                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `--color={yes\|no\|auto*}`                        | Enable or disable color text                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `--history-file={yes*\|no}`                       | Load or save history                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `--depwarn={yes\|no*\|error}`                     | Enable or disable syntax and method deprecation warnings (`error` turns warnings into errors)                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `--warn-overwrite={yes\|no*}`                     | Enable or disable method overwrite warnings                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `--warn-scope={yes*\|no}`                         | Enable or disable warning for ambiguous top-level scope                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `-C`, `--cpu-target <target>`                     | Limit usage of CPU features up to `<target>`; set to `help` to see the available options                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| `-O`, `--optimize={0\|1\|2*\|3}`                  | Set the optimization level (level is 3 if `-O` is used without a level) ($)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `--min-optlevel={0*\|1\|2\|3}`                    | Set the lower bound on per-module optimization                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `-g`, `--debug-info={0\|1*\|2}`                   | Set the level of debug info generation (level is 2 if `-g` is used without a level) ($)                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `--inline={yes\|no}`                              | Control whether inlining is permitted, including overriding `@inline` declarations                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `--check-bounds={yes\|no\|auto*}`                 | Emit bounds checks always, never, or respect `@inbounds` declarations ($)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `--math-mode={ieee\|user*}`                       | Always follow `ieee` floating point semantics or respect `@fastmath` declarations                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `--polly={yes*\|no}`                              | Enable or disable the polyhedral optimizer Polly (overrides @polly declaration)                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `--code-coverage[={none*\|user\|all}]`            | Count executions of source lines (omitting setting is equivalent to `user`)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `--code-coverage=@<path>`                         | Count executions but only in files that fall under the given file path/directory. The `@` prefix is required to select this option. A `@` with no path will track the current directory.                                                                                                                                                                                                                                                                                                                                                                      |
| `--code-coverage=tracefile.info`                  | Append coverage information to the LCOV tracefile (filename supports format tokens).                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `--track-allocation[={none*\|user\|all}]`         | Count bytes allocated by each source line (omitting setting is equivalent to "user")                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `--track-allocation=@<path>`                      | Count bytes but only in files that fall under the given file path/directory. The `@` prefix is required to select this option. A `@` with no path will track the current directory.                                                                                                                                                                                                                                                                                                                                                                           |
| `--task-metrics={yes\|no*}`                       | Enable the collection of per-task metrics                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `--bug-report=KIND`                               | Launch a bug report session. It can be used to start a REPL, run a script, or evaluate expressions. It first tries to use BugReporting.jl installed in current environment and falls back to the latest compatible BugReporting.jl if not. For more information, see `--bug-report=help`.                                                                                                                                                                                                                                                                     |
| `--heap-size-hint=<size>`                         | Forces garbage collection if memory usage is higher than the given value. The value may be specified as a number of bytes, optionally in units of KB, MB, GB, or TB, or as a percentage of physical memory with %. See [Memory Management and Garbage Collection](@ref man-memory-management) for more details.                                                                                                                                                                                                                                               |
| `--compile={yes*\|no\|all\|min}`                  | Enable or disable JIT compiler, or request exhaustive or minimal compilation                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `--output-o <name>`                               | Generate an object file (including system image data)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| `--output-ji <name>`                              | Generate a system image data file (.ji)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `--strip-metadata`                                | Remove docstrings and source location info from system image                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `--strip-ir`                                      | Remove IR (intermediate representation) of compiled functions                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `--output-unopt-bc <name>`                        | Generate unoptimized LLVM bitcode (.bc)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `--output-bc <name>`                              | Generate LLVM bitcode (.bc)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `--output-asm <name>`                             | Generate an assembly file (.s)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `--output-incremental={yes\|no*}`                 | Generate an incremental output file (rather than complete)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| `--trace-compile={stderr\|name}`                  | Print precompile statements for methods compiled during execution or save to stderr or a path. Methods that were recompiled are printed in yellow or with a trailing comment if color is not supported                                                                                                                                                                                                                                                                                                                                                        |
| `--trace-compile-timing`                          | If `--trace-compile` is enabled show how long each took to compile in ms                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| `--trace-dispatch={stderr\|name}`                 | Print precompile statements for methods dispatched during execution or save to stderr or a path.                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `--image-codegen`                                 | Force generate code in imaging mode                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| `--permalloc-pkgimg={yes\|no*}`                   | Copy the data section of package images into memory                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| `--trim={no*\|safe\|unsafe\|unsafe-warn}`         | Build a sysimage including only code provably reachable from methods marked by calling `entrypoint`. The three non-default options differ in how they handle dynamic call sites. In safe mode, such sites result in compile-time errors. In unsafe mode, such sites are allowed but the resulting binary might be missing needed code and can throw runtime errors. With unsafe-warn, such sites will trigger warnings at compile-time and might error at runtime.                                                                                            |

`--option={...}` の形式を持つオプションは、`--option=value` または `--option value` として指定できます。例えば、`julia --banner=no` は `julia --banner no` と同等です。これは、出力用のファイル名を取るオプションに特に関連しており、（例えば）`--trace-compile` の引数を指定し忘れると、その後のオプションがファイル名として解釈され、意図せず上書きされる可能性があります。

`--option[=...]` の形式のオプションは、`--option value` として指定することは**できません**。代わりに `--option=value` として指定する必要があります（引数が提供されない場合は単に `--option` として指定できます）。

!!! compat "Julia 1.1"
    Julia 1.0では、デフォルトの `--project=@.` オプションは、Gitリポジトリのルートディレクトリから `Project.toml` ファイルを検索しませんでした。Julia 1.1以降は、検索するようになりました。

