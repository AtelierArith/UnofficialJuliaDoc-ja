# [Command-line Interface](@id cli)

## Using arguments inside scripts

`julia` を使ってスクリプトを実行する場合、スクリプトに追加の引数を渡せます。

```
$ julia script.jl arg1 arg2...
```

これらの追加のコマンドライン引数は、グローバル定数 `ARGS` に渡されます。スクリプト自体の名前は、グローバル変数 `PROGRAM_FILE` に渡されます。コマンドラインで `-e` オプションを使って Julia の式を指定した場合も `ARGS` は設定されます（下記の `julia` のヘルプ出力を参照）が、`PROGRAM_FILE` は空になります。たとえば、スクリプトに渡された引数を表示するだけなら、次のようにできます。

```
$ julia -e 'println(PROGRAM_FILE); for x in ARGS; println(x); end' foo bar

foo
bar
```

または、このコードをスクリプトに記述して実行することもできます。

```
$ echo 'println(PROGRAM_FILE); for x in ARGS; println(x); end' > script.jl
$ julia script.jl foo bar
script.jl
foo
bar
```

`--` 区切り文字を使うと、スクリプトファイルに渡すコマンドライン引数と Julia に渡す引数を分けられます。

```
$ julia --color=yes -O -- script.jl arg1 arg2..
```

Julia スクリプトの作成については、[Scripting](@ref man-scripting) も参照してください。

## The `Main.main` entry point

Julia 1.11 以降、`Base` はマクロ `@main` をエクスポートします。このマクロはシンボル `main` に展開されますが、スクリプトまたは式の実行が終了した時点で、関数 `Main.main` が定義されており、`@main` マクロを使ってこの動作を有効にしている場合、`julia` は `Main.main(Base.ARGS)` の実行を試みます。

この機能の動作を確認するため、次の定義を見てみましょう。

```julia
(@main)(args) = println("Hello $(args[1])!")
```

上記のスクリプトを `julia script.jl "Buddy"` で実行すると、`(@main)` を明示的に呼び出していなくても、`(@main)` が自動的に実行され、「Hello Buddy!」と表示されます。

`(@main)` 関数の戻り値は、終了コード `0` となる `nothing` か、終了コードとなる `Cint` に変換可能な値でなければなりません。

```
$ julia -e "(@main)(args) = nothing"; echo $?0
0
$ julia -e "(@main)(args) = 1"; echo $?
1
```

通常、終了コードは `0:255` の範囲ですが、戻り値の解釈は OS によって異なる場合があります。

この機能は、コンパイル済みのワークフローと対話型ワークフローを統合しやすくすることを目的としています。コンパイル済みのワークフローでは、`main` 関数を定義するコードの読み込みと、その関数の呼び出しが、場所や時間の点で分離されている場合があります。一方、対話型ワークフローでは、評価したスクリプトまたは式の末尾で `exit(main(ARGS))` を明示的に呼び出すのと同じ動作になります。

!!! compat "Julia 1.11"
    特別なエントリーポイント `Main.main` は Julia 1.11 で追加されました。以前の Julia バージョンとの互換性を保つには、スクリプトの末尾に `@isdefined(var"@main") ? (@main) : exit(main(ARGS))` を明示的に追加してください。


この動作をするのは、`Main` モジュール内の `main` バインディングだけです。また、定義を含むモジュール内でマクロ `@main` が使われている場合に限ります。

たとえば、`main` の代わりに `hello` を使っても、`hello` 関数は実行されません。

```
$ julia -e 'hello(args) = println("Hello World!")'
$
```

また、単に `main` を定義しただけでも実行されません。

```
$ julia -e 'main(args) = println("Hello World!")'
$
```

ただし、この機能を有効にするのは、定義時でなくてもかまいません。

```
$ julia -e 'main(args) = println("Hello World!"); @main'
Hello World!
$
```

`main` バインディングは、パッケージからインポートできます。次のように定義された *hello world* パッケージは、

```
module Hello

export main
(@main)(args) = println("Hello from the package!")

end
```

次のように使用できます。

```
$ julia -e 'using Hello'
Hello from the package!
$ julia -e 'import Hello' # N.B.: Execution depends on the binding not whether the package is loaded
$
```

ただし、現在のベストプラクティスでは、アプリケーションコードと再利用可能なライブラリコードを同じパッケージに混在させないことが推奨されています。補助的なアプリケーションは、別のパッケージとして配布するか、パッケージの `bin` フォルダー内に別個の `main` エントリーポイントを持つスクリプトとして配布できます。

## Parallel mode

Julia は、`-p` または `--machine-file` オプションを使って並列モードで起動できます。`-p n` は追加の `n` 個のワーカープロセスを起動し、`--machine-file file` はファイル `file` の各行に対してワーカーを起動します。`file` で定義するマシンには、パスワードなしの `ssh` ログインでアクセスでき、現在のホストと同じ場所に Julia がインストールされている必要があります。各マシンの定義形式は `[count*][user@]host[:port] [bind_addr[:port]]` です。`user` の既定値は現在のユーザー、`port` の既定値は標準の SSH ポートです。`count` はそのノードで起動するワーカー数で、既定値は 1 です。省略可能な `bind-to bind_addr[:port]` には、他のワーカーがこのワーカーへの接続に使う IP アドレスとポートを指定します。

## Startup file

Julia の起動時に毎回実行したいコードがある場合は、`~/.julia/config/startup.jl` に記述できます。

```
$ echo 'println("Greetings! 你好! 안녕하세요?")' > ~/.julia/config/startup.jl
$ julia
Greetings! 你好! 안녕하세요?

...
```

Julia を初めて実行すると `~/.julia` ディレクトリが作成されますが、これを使う場合は `~/.julia/config` フォルダーと `~/.julia/config/startup.jl` ファイルを自分で作成する必要がある場合があります。

起動コードを [The Julia REPL](@ref) でのみ実行し、たとえばスクリプトで `julia` を実行したときには実行しないようにするには、`startup.jl` で [`atreplinit`](@ref) を使います。

```julia
atreplinit() do repl
    # ...
end
```

[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) が設定されている場合、起動ファイルはその場所に置く必要があります。つまり、`$JULIA_DEPOT_PATH/config/startup.jl` です。

## [Command-line switches for Julia](@id command-line-interface)

Julia コードの実行方法やオプションの指定方法には、`perl` や `ruby` プログラムと同様、さまざまな方法があります。

```
julia [switches] -- [programfile] [args...]
```

以下に、julia の起動時に使用できるコマンドラインスイッチをすべて示します（「*」は該当する場合の既定値を示し、「($)」が付いた設定はパッケージのプリコンパイルを引き起こすことがあります）。

| スイッチ                                              | 説明                                                                                                                                                                                                                                                                                                                                               |
|:------------------------------------------------- |:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `-v`, `--version`                                 | バージョン情報を表示する                                                                                                                                                                                                                                                                                                                                     |
| `-h`, `--help`                                    | コマンドラインオプション（このメッセージ）を表示する                                                                                                                                                                                                                                                                                                                       |
| `--help-hidden`                                   | `-h` に表示されない、あまり使われないオプションを表示する                                                                                                                                                                                                                                                                                                                  |
| `--project[={<dir>\|@temp\|@.}]`                  | `<dir>` をアクティブなプロジェクト／環境として設定する。または、`@temp` を使って一時的な環境を作成する。既定の `@.` オプションでは、`Project.toml` または `JuliaProject.toml` ファイルが見つかるまで親ディレクトリを検索する。                                                                                                                                                                                                     |
| `-J`, `--sysimage <file>`                         | 指定したシステムイメージファイルを使って起動する                                                                                                                                                                                                                                                                                                                         |
| `-H`, `--home <dir>`                              | `julia` 実行ファイルの場所を設定する                                                                                                                                                                                                                                                                                                                           |
| `--startup-file={yes*\|no}`                       | `JULIA_DEPOT_PATH/config/startup.jl` を読み込む。[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) 環境変数が設定されていない場合は、`~/.julia/config/startup.jl` を読み込む                                                                                                                                                                                                       |
| `--handle-signals={yes*\|no}`                     | Julia の既定のシグナルハンドラーを有効または無効にする                                                                                                                                                                                                                                                                                                                   |
| `--sysimage-native-code={yes*\|no}`               | 利用可能な場合、システムイメージのネイティブコードを使う                                                                                                                                                                                                                                                                                                                     |
| `--compiled-modules={yes*\|no\|existing\|strict}` | モジュールのインクリメンタルなプリコンパイルを有効または無効にする。`existing` オプションでは、以前にプリコンパイルされた既存のコンパイル済みモジュールを使用できますが、新しいプリコンパイルファイルは作成されません。`strict` オプションも同様ですが、プリコンパイルファイルが見つからない場合はエラーになります。                                                                                                                                                                             |
| `--pkgimages={yes*\|no\|existing}`                | pkgimages 形式のネイティブコードキャッシュの使用を有効または無効にする。`existing` オプションでは既存の pkgimages を使用できますが、新しいものは作成されません                                                                                                                                                                                                                                                  |
| `-e`, `--eval <expr>`                             | `<expr>` を評価する                                                                                                                                                                                                                                                                                                                                   |
| `-E`, `--print <expr>`                            | `<expr>` を評価し、結果を表示する                                                                                                                                                                                                                                                                                                                            |
| `-m`, `--module <Package> [args]`                 | `Package` のエントリーポイント（`@main` 関数）を `args` で実行する                                                                                                                                                                                                                                                                                                   |
| `-L`, `--load <file>`                             | すべてのプロセッサで `<file>` を直ちに読み込む                                                                                                                                                                                                                                                                                                                     |
| `-t`, `--threads {auto\|N[,auto\|M]}`             | N[+M] 個のスレッドを有効にする。N 個は `default` スレッドプールに割り当てられ、M が指定されている場合は M 個が `interactive` スレッドプールに割り当てられる。`auto` は有用な既定のスレッド数を推定しますが、正確な動作は将来変更される可能性があります。現在は、OS 固有のアフィニティ割り当てインターフェースがサポートされている場合（Linux および Windows）は、そのインターフェースに基づく Julia プロセスに割り当てられた CPU 数を N に設定します。サポートされていない場合（MacOS）、またはプロセスのアフィニティが設定されていない場合は、CPU スレッド数を N に設定し、M は 1 に設定します。 |
| `--gcthreads=N[,M]`                               | GC のマークフェーズに N 個のスレッドを使い、GC の並行スイープフェーズに M 個（0 または 1）のスレッドを使う。N は計算スレッド数に設定され、M が指定されていない場合は 0 に設定される。詳しくは [Memory Management and Garbage Collection](@ref man-memory-management) を参照。                                                                                                                                                           |
| `-p`, `--procs {N\|auto}`                         | 整数値 N を指定すると、ローカルのワーカープロセスを N 個追加で起動する。`auto` は、ローカル CPU スレッド（論理コア）数と同じ数のワーカーを起動する                                                                                                                                                                                                                                                               |
| `--machine-file <file>`                           | `<file>` に列挙されたホスト上でプロセスを実行する                                                                                                                                                                                                                                                                                                                    |
| `-i`, `--interactive`                             | 対話モード。REPL が起動し、`isinteractive()` は true になる                                                                                                                                                                                                                                                                                                     |
| `-q`, `--quiet`                                   | 起動時の出力を抑制する。バナーを表示せず、REPL の警告も抑制する                                                                                                                                                                                                                                                                                                               |
| `--banner={yes\|no\|short\|auto*}`                | 起動バナーを有効または無効にする                                                                                                                                                                                                                                                                                                                                 |
| `--color={yes\|no\|auto*}`                        | 色付きテキストを有効または無効にする                                                                                                                                                                                                                                                                                                                               |
| `--history-file={yes*\|no}`                       | 履歴を読み込む、または保存する                                                                                                                                                                                                                                                                                                                                  |
| `--depwarn={yes\|no*\|error}`                     | 構文およびメソッドの非推奨警告を有効または無効にする（`error` は警告をエラーに変える）                                                                                                                                                                                                                                                                                                  |
| `--warn-overwrite={yes\|no*}`                     | メソッドの上書きに関する警告を有効または無効にする                                                                                                                                                                                                                                                                                                                        |
| `--warn-scope={yes*\|no}`                         | トップレベルスコープの曖昧さに関する警告を有効または無効にする                                                                                                                                                                                                                                                                                                                  |
| `-C`, `--cpu-target <target>`                     | CPU 機能の使用を `<target>` までに制限する。利用可能なオプションを確認するには `help` を指定する                                                                                                                                                                                                                                                                                     |
| `-O`, `--optimize={0\|1\|2*\|3}`                  | 最適化レベルを設定する（レベルを指定せずに `-O` を使った場合、レベルは 3）($)                                                                                                                                                                                                                                                                                                     |
| `--min-optlevel={0*\|1\|2\|3}`                    | モジュールごとの最適化レベルの下限を設定する                                                                                                                                                                                                                                                                                                                           |
| `-g`, `--debug-info={0\|1*\|2}`                   | デバッグ情報の生成レベルを設定する（レベルを指定せずに `-g` を使った場合、レベルは 2）($)                                                                                                                                                                                                                                                                                               |
| `--inline={yes*\|no}`                             | インライン化を許可するかどうかを制御する。`@inline` 宣言を上書きする場合も含む                                                                                                                                                                                                                                                                                                     |
| `--check-bounds={yes\|no\|auto*}`                 | 境界チェックを常に行うか、行わないか、または `@inbounds` 宣言に従うかを指定する ($)                                                                                                                                                                                                                                                                                               |
| `--math-mode={ieee\|user*}`                       | 常に `ieee` の浮動小数点演算セマンティクスに従うか、`@fastmath` 宣言に従うかを指定する                                                                                                                                                                                                                                                                                            |
| `--polly={yes*\|no}`                              | 多面体最適化器 Polly を有効または無効にする（@polly 宣言より優先）                                                                                                                                                                                                                                                                                                         |
| `--code-coverage[={none*\|user\|all}]`            | ソース行ごとの実行回数を数える（設定を省略した場合は `user` と同じ）                                                                                                                                                                                                                                                                                                           |
| `--code-coverage=@<path>`                         | 指定したファイルパス／ディレクトリ配下にあるファイルだけを対象に実行回数を数える。このオプションを選ぶには `@` プレフィックスが必要。パスを指定しない `@` は、現在のディレクトリを対象にする                                                                                                                                                                                                                                              |
| `--code-coverage=tracefile.info`                  | カバレッジ情報を LCOV トレースファイルに追記する（ファイル名では書式トークンを使用可能）                                                                                                                                                                                                                                                                                                  |
| `--track-allocation[={none*\|user\|all}]`         | ソース行ごとに割り当てられたバイト数を数える（設定を省略した場合は "user" と同じ）                                                                                                                                                                                                                                                                                                    |
| `--track-allocation=@<path>`                      | 指定したファイルパス／ディレクトリ配下にあるファイルだけを対象にバイト数を数える。このオプションを選ぶには `@` プレフィックスが必要。パスを指定しない `@` は、現在のディレクトリを対象にする                                                                                                                                                                                                                                              |
| `--task-metrics={yes\|no*}`                       | タスクごとのメトリクス収集を有効にする                                                                                                                                                                                                                                                                                                                              |
| `--bug-report=KIND`                               | バグ報告セッションを起動する。REPL の起動、スクリプトの実行、式の評価に使用できる。まず現在の環境にインストールされている BugReporting.jl を使い、利用できない場合は互換性のある最新の BugReporting.jl を使用する。詳しくは `--bug-report=help` を参照。                                                                                                                                                                                       |
| `--heap-size-hint=<size>`                         | メモリ使用量が指定値を超えた場合にガベージコレクションを実行する。値はバイト数、KB、MB、GB、TB 単位を付けた数値、または % を付けた物理メモリに対する割合で指定できる。詳しくは [Memory Management and Garbage Collection](@ref man-memory-management) を参照。                                                                                                                                                                        |
| `--compile={yes*\|no\|all\|min}`                  | JIT コンパイラーを有効または無効にする。または、網羅的コンパイル／最小限のコンパイルを指定する                                                                                                                                                                                                                                                                                                |
| `--output-o <name>`                               | オブジェクトファイルを生成する（システムイメージデータを含む）                                                                                                                                                                                                                                                                                                                  |
| `--output-ji <name>`                              | システムイメージデータファイル（.ji）を生成する                                                                                                                                                                                                                                                                                                                        |
| `--strip-metadata`                                | システムイメージから docstring とソース位置情報を削除する                                                                                                                                                                                                                                                                                                               |
| `--strip-ir`                                      | コンパイル済み関数の IR（中間表現）を削除する                                                                                                                                                                                                                                                                                                                         |
| `--output-unopt-bc <name>`                        | 最適化されていない LLVM ビットコード（.bc）を生成する                                                                                                                                                                                                                                                                                                                  |
| `--output-bc <name>`                              | LLVM ビットコード（.bc）を生成する                                                                                                                                                                                                                                                                                                                            |
| `--output-asm <name>`                             | アセンブリファイル（.s）を生成する                                                                                                                                                                                                                                                                                                                               |
| `--output-incremental={yes\|no*}`                 | 完全な出力ではなく、インクリメンタルな出力ファイルを生成する                                                                                                                                                                                                                                                                                                                   |
| `--trace-compile={stderr\|name}`                  | 実行中にコンパイルされたメソッドのプリコンパイル文を表示するか、stderr または指定したパスに保存する。再コンパイルされたメソッドは黄色で表示される。色がサポートされていない場合は、末尾のコメントで示される                                                                                                                                                                                                                                        |
| `--trace-compile-timing`                          | `--trace-compile` が有効な場合、各メソッドのコンパイルにかかった時間をミリ秒単位で表示する                                                                                                                                                                                                                                                                                           |
| `--trace-dispatch={stderr\|name}`                 | 実行中にディスパッチされたメソッドのプリコンパイル文を表示するか、stderr または指定したパスに保存する                                                                                                                                                                                                                                                                                           |
| `--trace-eval[={no*\|loc\|full}]`                 | 評価中のトップレベル式を表示する。`loc` は位置情報のみ、`full` は式全体を表示する（設定を省略した場合は `loc` と同じ）。評価中の最外側の式のみを表示し、内部の関数呼び出しは表示しない。[`Base.TRACE_EVAL`](@ref) も参照。                                                                                                                                                                                                             |
| `--image-codegen`                                 | イメージングモードでのコード生成を強制する                                                                                                                                                                                                                                                                                                                            |
| `--permalloc-pkgimg={yes\|no*}`                   | パッケージイメージのデータセクションをメモリにコピーする                                                                                                                                                                                                                                                                                                                     |
| `--trim={no*\|safe\|unsafe\|unsafe-warn}`         | `entrypoint` の呼び出しでマークされたメソッドから、到達可能であることが証明されたコードだけを含む sysimage をビルドする。既定以外の 3 つのオプションは、動的な呼び出し箇所の扱いが異なる。safe モードでは、そのような箇所がコンパイル時エラーになる。unsafe モードではそのような箇所が許可されますが、生成されたバイナリに必要なコードが含まれず、実行時エラーが発生する可能性があります。unsafe-warn では、そのような箇所に対してコンパイル時に警告が出され、実行時にエラーが発生する可能性があります。                                                                    |

`--option={...}` 形式のオプションは、`--option=value` または `--option value` のどちらの形式でも指定できます。たとえば、`julia --banner=no` は `julia --banner no` と同じです。これは、出力先のファイル名を取るオプションで特に重要です。たとえば `--trace-compile` の引数を指定し忘れると、後続のオプションがファイル名として解釈され、意図せず上書きされる可能性があります。

`--option[=...]` 形式のオプションは、`--option value` 形式では指定できず、`--option=value` 形式で指定する必要があります（引数を指定しない場合は、単に `--option` と指定できます）。

!!! compat "Julia 1.1"
    Julia 1.0 では、既定の `--project=@.` オプションは、Git リポジトリのルートディレクトリより上位にある `Project.toml` ファイルを検索しませんでした。Julia 1.1 以降では検索します。

