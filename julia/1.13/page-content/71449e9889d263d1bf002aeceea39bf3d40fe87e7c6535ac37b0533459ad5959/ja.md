```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/Logging/docs/src/index.md"
```

# [Logging](@id man-logging)

[`Logging`](@ref Logging.Logging) モジュールは、計算の履歴や進行状況をイベントログとして記録する機能を提供します。イベントは、たとえば次のように、ソースコードにログ出力文を挿入して生成します。

```julia
@warn "Abandon printf debugging, all ye who enter here!"
┌ Warning: Abandon printf debugging, all ye who enter here!
└ @ Main REPL[1]:1
```

ソースコードのあちこちに `println()` の呼び出しを埋め込む方法と比べて、このシステムにはいくつかの利点があります。まず、ソースコードを編集せずにメッセージの表示や形式を制御できます。たとえば、上記の `@warn` とは異なり、

```julia
@debug "The sum of some values $(sum(rand(100)))"
```

は、デフォルトでは何も出力しません。また、後で無視されるメッセージは評価されないため、このようなデバッグ文をソースコードに残しておいても、ほとんどコストはかかりません。この場合、デバッグログが有効になっていない限り、`sum(rand(100))` と、それに伴う文字列処理は実行されません。

次に、ログ機能では、任意のデータをキーと値のペアとして各イベントに付加できます。これにより、ローカル変数やその他のプログラム状態を記録し、後で分析できます。たとえば、ローカル配列変数 `A` とベクトル `v` の合計を、キー `s` の値として付加するには、次のようにします。

```jldoctest
A = ones(Int, 4, 4)
v = ones(100)
@info "Some variables"  A  s=sum(v)

# output
┌ Info: Some variables
│   A =
│    4×4 Matrix{Int64}:
│     1  1  1  1
│     1  1  1  1
│     1  1  1  1
│     1  1  1  1
└   s = 100.0
```

すべてのログマクロ `@debug`、`@info`、`@warn`、`@error` には共通の機能があり、より汎用的なマクロ [`@logmsg`](@ref) のドキュメントで詳しく説明されています。

## Log event structure

各イベントには複数のデータが含まれます。ユーザーが指定するものもあれば、自動的に取得されるものもあります。まず、ユーザーが指定するデータを見てみましょう。

  * *ログレベル*は、メッセージの大まかな分類で、早期フィルタリングに使われます。標準のレベルには [`LogLevel`](@ref) 型のものがいくつかあり、ユーザー定義のレベルも使用できます。それぞれ用途が異なります。

      * [`Logging.Debug`](@ref)（ログレベル -1000）は、プログラム開発者向けの情報です。このイベントはデフォルトで無効になっています。
      * [`Logging.Info`](@ref)（ログレベル 0）は、ユーザー向けの一般的な情報です。`println` を直接使う代わりになるものと考えてください。
      * [`Logging.Warn`](@ref)（ログレベル 1000）は、問題が発生して対応が必要になる可能性はあるものの、現時点ではプログラムが動作を続けていることを示します。
      * [`Logging.Error`](@ref)（ログレベル 2000）は、問題が発生し、少なくともこのコード部分では復旧が難しいことを示します。例外をスローすれば必要な情報をすべて伝えられることが多いため、このログレベルは不要な場合もあります。
  * *メッセージ*は、イベントを説明するオブジェクトです。慣例として、メッセージに渡される `AbstractString` は Markdown 形式とみなされます。それ以外の型は、テキストベースの出力では `print(io, obj)` または `string(obj)` を使って表示されます。また、インストールされているロガーで使われる他のマルチメディア表示では、`show(io,mime,obj)` が使われる場合があります。
  * 任意の*キーと値のペア*を使って、各イベントに任意のデータを付加できます。イベントの解釈に影響する慣例的な意味を持つキーもあります（[`@logmsg`](@ref) を参照）。

各イベントには、システムによって次の標準情報も付加されます。

  * ログマクロが展開された `module`。
  * ソースコード内でログマクロが現れる `file` と `line`。
  * ログマクロが現れる*ソースコード文*を一意に識別する固定の識別子であるメッセージ `id`。この識別子は、ログ文自体が変わらない限り、ファイルのソースコードが変更されても比較的安定するように設計されています。
  * イベントの `group`。デフォルトでは、拡張子を除いたファイル名が設定されます。これを使うと、ログレベルより細かい分類（たとえば、すべての非推奨警告に `:depwarn` というグループを割り当てるなど）や、モジュールをまたいだ、あるいはモジュール内での論理的な分類ができます。

イベントの発生時刻など、有用な情報の一部がデフォルトでは含まれないことに注意してください。こうした情報の取得にはコストがかかる場合があり、また、現在のロガーが*動的に*取得できる情報だからです。必要に応じて時刻、バックトレース、グローバル変数の値などをイベントデータに追加する [custom logger](@ref AbstractLogger-interface) を簡単に定義できます。

## Processing log events

例から分かるように、ログ文ではログイベントの出力先や処理方法を指定しません。これは、システムの合成可能性を高め、並行処理でも自然に使えるようにする重要な設計上の特徴です。そのために、次の2つの関心事を分離しています。

  * ログイベントの*生成*は、イベントを発生させる場所と含める情報を決めるモジュール作成者の役割です。
  * ログイベントの*処理*（表示、フィルタリング、集約、記録）は、複数のモジュールを連携するアプリケーションにまとめるアプリケーション作成者の役割です。

### Loggers

イベントの処理は*ロガー*が行います。ロガーは、イベントを受け取る最初のユーザー設定可能なコードです。すべてのロガーは [`AbstractLogger`](@ref) のサブタイプでなければなりません。

イベントが発生すると、タスクローカルなロガーを探し、見つからない場合はグローバルロガーを使います。アプリケーションコードはログイベントの処理方法を把握しており、呼び出しスタックの上位にあるため、呼び出しスタックをたどってロガーを見つけるという考え方です。つまり、ロガーは*動的スコープ*を持ちます。（これは、モジュール作成者が明示的に指定するか、単純なグローバル変数として用意する、*字句スコープ*のロガーを使うログフレームワークとは対照的です。そのようなシステムでは、複数のモジュールの機能を組み合わせる際にログを制御しにくくなります。）

グローバルロガーは [`global_logger`](@ref) で設定でき、タスクローカルなロガーは [`with_logger`](@ref) で制御できます。新しく生成されたタスクは、親タスクのロガーを引き継ぎます。

ライブラリには3種類のロガーが用意されています。[`ConsoleLogger`](@ref) は、REPL の起動時に使われるデフォルトのロガーです。イベントを読みやすいテキスト形式で表示し、書式やフィルタリングを簡単かつ使いやすく制御できるようにします。[`NullLogger`](@ref) は、必要に応じてすべてのメッセージを破棄するための便利なロガーで、ログ機能における [`devnull`](@ref) ストリームに相当します。[`SimpleLogger`](@ref) は非常に単純なテキスト整形ロガーで、主にログシステム自体のデバッグに使います。

カスタムロガーでは、[reference section](@ref AbstractLogger-interface) に記載されている関数をオーバーロードしてください。

### Early filtering and message handling

イベントが発生すると、破棄されるメッセージの生成を避けるため、いくつかの早期フィルタリングが行われます。

1. メッセージのログレベルを、グローバルな最小レベル（[`disable_logging`](@ref) で設定）と比較します。これは大まかな設定ですが、非常に低コストです。
2. 現在のロガーの状態を取得し、[`Logging.min_enabled_level`](@ref) の呼び出しで得られる、ロガーにキャッシュされた最小レベルとメッセージのレベルを比較します。この動作は環境変数で上書きできます（詳細は後述）。
3. 現在のロガーを引数として [`Logging.shouldlog`](@ref) 関数を呼び出します。この関数には、静的に計算できる最小限の情報（レベル、モジュール、グループ、ID）が渡されます。特に、`shouldlog` にはイベント `id` が渡され、キャッシュされた述語に基づいてイベントを早期に破棄できます。

これらのチェックをすべて通過すると、メッセージとキーと値のペアが完全に評価され、[`Logging.handle_message`](@ref) 関数を通じて現在のロガーに渡されます。`handle_message()` は必要に応じて追加のフィルタリングを行い、イベントを画面に表示したり、ファイルに保存したりできます。

ログイベントの生成中に発生した例外は、デフォルトで捕捉され、ログに記録されます。これにより、個々のイベントに問題があってもアプリケーションがクラッシュするのを防げます。本番システムで、あまり使われないデバッグイベントを有効にする場合に便利です。この動作は、ロガーの型ごとに [`Logging.catch_exceptions`](@ref) を拡張してカスタマイズできます。

## Testing log events

ログイベントは通常のコード実行に伴う副作用ですが、特定の情報メッセージや警告をテストしたい場合もあるでしょう。`Test` モジュールは、ログイベントのストリームに対してパターンマッチングを行う [`@test_logs`](@ref) マクロを提供します。

## Environment variables

メッセージのフィルタリングは [`JULIA_DEBUG`](@ref JULIA_DEBUG) 環境変数で制御できます。これは、ファイルやモジュール単位でデバッグログを有効にする簡単な方法です。`JULIA_DEBUG=loading` を指定して Julia を起動すると、`loading.jl` 内の `@debug` ログメッセージが有効になります。たとえば、Linux のシェルでは次のようにします。

```
$ JULIA_DEBUG=loading julia -e 'using OhMyREPL'
┌ Debug: Rejecting cache file /home/user/.julia/compiled/v0.7/OhMyREPL.ji due to it containing an incompatible cache header
└ @ Base loading.jl:1328
[ Info: Recompiling stale cache file /home/user/.julia/compiled/v0.7/OhMyREPL.ji for module OhMyREPL
┌ Debug: Rejecting cache file /home/user/.julia/compiled/v0.7/Tokenize.ji due to it containing an incompatible cache header
└ @ Base loading.jl:1328
...
```

Windows では、`CMD` で `set JULIA_DEBUG="loading"` を実行すると同じ設定ができ、`Powershell` では `$env:JULIA_DEBUG="loading"` を使います。

同様に、この環境変数を使って `Pkg` などのモジュールや、モジュールのルート（[`Base.moduleroot`](@ref) を参照）のデバッグログを有効にできます。すべてのデバッグログを有効にするには、特別な値 `all` を指定します。

REPL からデバッグログを有効にするには、`ENV["JULIA_DEBUG"]` に対象モジュールの名前を設定します。REPL で定義された関数はモジュール `Main` に属します。これらの関数のログは、次のように有効にできます。

```julia-repl
julia> foo() = @debug "foo"
foo (generic function with 1 method)

julia> foo()

julia> ENV["JULIA_DEBUG"] = Main
Main

julia> foo()
┌ Debug: foo
└ @ Main REPL[1]:1

```

複数のモジュールのデバッグログを有効にするには、カンマで区切って指定します。`JULIA_DEBUG=loading,Main`。

## Examples

### Example: Writing log events to a file

ログイベントをファイルに書き出すと便利な場合があります。タスクローカルロガーとグローバルロガーを使って情報をテキストファイルに書き込む例を示します。

```julia-repl
# Load the logging module
julia> using Logging

# Open a textfile for writing
julia> io = open("log.txt", "w+")
IOStream(<file log.txt>)

# Create a simple logger
julia> logger = SimpleLogger(io)
SimpleLogger(IOStream(<file log.txt>), Info, Dict{Any,Int64}())

# Log a task-specific message
julia> with_logger(logger) do
           @info("a context specific log message")
       end

# Write all buffered messages to the file
julia> flush(io)

# Set the global logger to logger
julia> global_logger(logger)
SimpleLogger(IOStream(<file log.txt>), Info, Dict{Any,Int64}())

# This message will now also be written to the file
julia> @info("a global log message")

# Close the file
julia> close(io)
```

### Example: Enable debug-level messages

ログレベルが [`Logging.Debug`](@ref) 以上のメッセージをすべて通す [`ConsoleLogger`](@ref) を作成する例を示します。

```julia-repl
julia> using Logging

# Create a ConsoleLogger that prints any log messages with level >= Debug to stderr
julia> debuglogger = ConsoleLogger(stderr, Logging.Debug)

# Enable debuglogger for a task
julia> with_logger(debuglogger) do
           @debug "a context specific log message"
       end

# Set the global logger
julia> global_logger(debuglogger)
```

## Reference

### Logging module

```@docs
Logging.Logging
```

### Creating events

```@docs
Logging.@logmsg
Logging.LogLevel
Logging.Debug
Logging.Info
Logging.Warn
Logging.Error
Logging.BelowMinLevel
Logging.AboveMaxLevel
```

### [Processing events with AbstractLogger](@id AbstractLogger-interface)

イベント処理は、`AbstractLogger` に関連付けられた関数をオーバーライドして制御します。

| 実装するメソッド                            |             | 概要                 |
|:----------------------------------- |:----------- |:------------------ |
| [`Logging.handle_message`](@ref)    |             | ログイベントを処理する        |
| [`Logging.shouldlog`](@ref)         |             | イベントを早期にフィルタリングする  |
| [`Logging.min_enabled_level`](@ref) |             | 受け入れるイベントのログレベルの下限 |
| **任意のメソッド**                         | **デフォルト定義** | **概要**             |
| [`Logging.catch_exceptions`](@ref)  | `true`      | イベント評価中の例外を捕捉する    |

```@docs
Logging.AbstractLogger
Logging.handle_message
Logging.shouldlog
Logging.min_enabled_level
Logging.catch_exceptions
Logging.disable_logging
```

### Using Loggers

ロガーの設定と確認：

```@docs
Logging.global_logger
Logging.with_logger
Logging.current_logger
```

システムに用意されているロガー：

```@docs
Logging.NullLogger
Logging.ConsoleLogger
Logging.SimpleLogger
```
