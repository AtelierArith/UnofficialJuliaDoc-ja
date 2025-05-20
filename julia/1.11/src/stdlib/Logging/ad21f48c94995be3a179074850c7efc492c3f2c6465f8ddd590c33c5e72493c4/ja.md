```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/Logging/docs/src/index.md"
```

# [Logging](@id man-logging)

[`Logging`](@ref Logging.Logging) モジュールは、計算の履歴と進行状況をイベントのログとして記録する方法を提供します。イベントは、ソースコードにログ記録ステートメントを挿入することによって作成されます。例えば：

```julia
@warn "Abandon printf debugging, all ye who enter here!"
┌ Warning: Abandon printf debugging, all ye who enter here!
└ @ Main REPL[1]:1
```

システムは、ソースコードに`println()`の呼び出しを散りばめることに対していくつかの利点を提供します。まず、ソースコードを編集することなく、メッセージの可視性と表示を制御できる点です。たとえば、上記の`@warn`とは対照的に

```julia
@debug "The sum of some values $(sum(rand(100)))"
```

デフォルトでは出力を生成しません。さらに、このようなデバッグステートメントをソースコードに残しておくのは非常に安価です。なぜなら、システムはメッセージが後で無視される場合、評価を回避するからです。この場合、`sum(rand(100))` と関連する文字列処理は、デバッグログが有効になっていない限り、決して実行されることはありません。

第二に、ログツールを使用すると、各イベントに任意のデータをキーと値のペアのセットとして添付できます。これにより、後で分析するためにローカル変数や他のプログラムの状態をキャプチャできます。たとえば、ローカル配列変数 `A` とベクトル `v` の合計をキー `s` として添付するには、次のようにします。

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

すべてのログ記録マクロ `@debug`、`@info`、`@warn` および `@error` は、より一般的なマクロ [`@logmsg`](@ref) のドキュメントで詳細に説明されている共通の機能を共有しています。

## Log event structure

各イベントは、ユーザーによって提供されたデータと自動的に抽出されたデータのいくつかのデータを生成します。まず、ユーザー定義のデータを見てみましょう：

  * *ログレベル*は、早期フィルタリングに使用されるメッセージの広範なカテゴリです。標準のレベルはいくつかあり、タイプは [`LogLevel`](@ref) です。ユーザー定義のレベルも可能です。それぞれの目的は異なります：

      * [`Logging.Debug`](@ref) (ログレベル -1000) はプログラムの開発者向けの情報です。これらのイベントはデフォルトで無効になっています。
      * [`Logging.Info`](@ref) (ログレベル 0) は、ユーザーへの一般的な情報のためのものです。これは、`println` を直接使用する代替手段と考えてください。
      * [`Logging.Warn`](@ref)（ログレベル1000）は、何か問題が発生しており、対処が必要な可能性が高いことを意味しますが、現時点ではプログラムはまだ動作しています。
      * [`Logging.Error`](@ref)（ログレベル2000）は、何かが間違っていることを意味し、このコードの部分では回復する可能性が低いです。しばしば、このログレベルは不要であり、例外をスローすることで必要な情報をすべて伝えることができます。
  * *メッセージ* はイベントを説明するオブジェクトです。慣例として、メッセージとして渡される `AbstractString` はマークダウン形式であると見なされます。他のタイプは、テキストベースの出力には `print(io, obj)` または `string(obj)` を使用して表示され、インストールされたロガーで使用される他のマルチメディア表示にはおそらく `show(io,mime,obj)` が使用されます。
  * オプショナルな *キー–バリュー ペア* は、各イベントに任意のデータを添付することを可能にします。いくつかのキーには、イベントの解釈に影響を与える慣習的な意味があります（[`@logmsg`](@ref) を参照）。

システムは各イベントに対していくつかの標準情報も生成します：

  * ログマクロが展開された`module`。
  * ソースコード内でログマクロが発生する`file`と`line`。
  * メッセージ `id` は、ロギングマクロが出現する *ソースコードステートメント* のユニークで固定された識別子です。この識別子は、ファイルのソースコードが変更されても比較的安定しているように設計されており、ロギングステートメント自体が同じである限り、変わりません。
  * イベントのための `group` は、デフォルトで拡張子なしのファイルの基本名に設定されています。 これは、ログレベルよりも細かくメッセージをカテゴリにグループ化するために使用できます（例えば、すべての非推奨警告はグループ `:depwarn` を持ちます）、またはモジュール内またはモジュール間で論理的なグループに分けるために使用できます。

注意すべきは、イベントの時間などの有用な情報がデフォルトでは含まれていないことです。これは、そのような情報を抽出するのが高コストであり、現在のロガーに対して*動的に*利用可能であるためです。必要に応じて、時間、バックトレース、グローバル変数の値、およびその他の有用な情報でイベントデータを補強するために、[custom logger](@ref AbstractLogger-interface)を定義するのは簡単です。

## Processing log events

例に示されているように、ログ記録のステートメントは、ログイベントがどこに行くのか、またはどのように処理されるのかについて言及していません。これは、システムを構成可能で同時使用に自然なものにする重要な設計機能です。これは、2つの異なる関心事を分離することによって実現されています：

  * *ログイベントの作成*は、イベントがトリガーされる場所や含める情報を決定する必要があるモジュールの著者の関心事です。
  * *ログイベントの処理* — つまり、表示、フィルタリング、集約、記録 — は、複数のモジュールを協力するアプリケーションにまとめる必要があるアプリケーション作成者の関心事です。

### Loggers

イベントの処理は *logger* によって行われ、これはイベントを見る最初のユーザー設定可能なコードです。すべてのロガーは [`AbstractLogger`](@ref) のサブタイプでなければなりません。

イベントがトリガーされると、適切なロガーはグローバルロガーをフォールバックとして使用し、タスクローカルロガーを探すことで見つけられます。ここでの考え方は、アプリケーションコードがログイベントをどのように処理すべきかを知っており、コールスタックの上部のどこかに存在するということです。したがって、ロガーを発見するためにコールスタックを上に向かって探る必要があります。つまり、ロガーは*動的スコープ*であるべきです。（これは、ロガーが*字句的スコープ*であるロギングフレームワークとの対比点です。モジュールの著者によって明示的に提供されるか、単純なグローバル変数として提供されます。そのようなシステムでは、複数のモジュールから機能を構成しながらロギングを制御するのが難しいです。）

グローバルロガーは [`global_logger`](@ref) で設定でき、タスクローカルロガーは [`with_logger`](@ref) を使用して制御されます。新しく生成されたタスクは親タスクのロガーを継承します。

ライブラリには3つのロガータイプが提供されています。 [`ConsoleLogger`](@ref) は、REPLを起動したときに表示されるデフォルトのロガーです。これは、イベントを読みやすいテキスト形式で表示し、フォーマットやフィルタリングに対してシンプルでユーザーフレンドリーな制御を提供しようとします。 [`NullLogger`](@ref) は、必要に応じてすべてのメッセージをドロップする便利な方法です。これは、 [`devnull`](@ref) ストリームのロギングに相当します。 [`SimpleLogger`](@ref) は、主にロギングシステム自体のデバッグに役立つ非常にシンプルなテキストフォーマットロガーです。

カスタムロガーは、[reference section](@ref AbstractLogger-interface)で説明されている関数のオーバーロードを備えている必要があります。

### Early filtering and message handling

イベントが発生すると、破棄されるメッセージの生成を避けるために、いくつかの初期フィルタリングステップが行われます：

1. メッセージログレベルは、グローバル最小レベル（[`disable_logging`](@ref)を介して設定）に対してチェックされます。これは粗雑ですが、非常に安価なグローバル設定です。
2. 現在のロガーの状態が確認され、メッセージレベルがロガーのキャッシュされた最小レベルと照合されます。これは [`Logging.min_enabled_level`](@ref) を呼び出すことで見つけられます。この動作は環境変数を介してオーバーライド可能です（詳細は後述します）。
3. [`Logging.shouldlog`](@ref) 関数は、現在のロガーを使用して呼び出され、いくつかの最小限の情報（レベル、モジュール、グループ、ID）が静的に計算されます。最も便利なのは、`shouldlog` にイベント `id` が渡され、キャッシュされた述語に基づいて早期にイベントを破棄するために使用できることです。

すべてのチェックが通過した場合、メッセージとキー–バリューのペアは完全に評価され、現在のロガーに [`Logging.handle_message`](@ref) 関数を介して渡されます。 `handle_message()` は必要に応じて追加のフィルタリングを行い、イベントを画面に表示したり、ファイルに保存したりします。

ログイベントを生成する際に発生する例外は、デフォルトでキャプチャされ、ログに記録されます。これにより、個々の壊れたイベントがアプリケーションをクラッシュさせるのを防ぎ、運用システムであまり使用されないデバッグイベントを有効にする際に役立ちます。この動作は、[`Logging.catch_exceptions`](@ref)を拡張することで、ロガータイプごとにカスタマイズできます。

## Testing log events

ログイベントは通常のコードを実行する副作用ですが、特定の情報メッセージや警告をテストしたい場合があるかもしれません。`Test`モジュールは、ログイベントストリームに対してパターンマッチングを行うために使用できる[`@test_logs`](@ref)マクロを提供します。

## Environment variables

メッセージフィルタリングは、[`JULIA_DEBUG`](@ref JULIA_DEBUG) 環境変数を通じて影響を受けることができ、ファイルやモジュールのデバッグログを有効にする簡単な方法として機能します。`JULIA_DEBUG=loading` でジュリアをロードすると、`loading.jl` 内の `@debug` ログメッセージがアクティブになります。例えば、Linuxシェルでは:

```
$ JULIA_DEBUG=loading julia -e 'using OhMyREPL'
┌ Debug: Rejecting cache file /home/user/.julia/compiled/v0.7/OhMyREPL.ji due to it containing an incompatible cache header
└ @ Base loading.jl:1328
[ Info: Recompiling stale cache file /home/user/.julia/compiled/v0.7/OhMyREPL.ji for module OhMyREPL
┌ Debug: Rejecting cache file /home/user/.julia/compiled/v0.7/Tokenize.ji due to it containing an incompatible cache header
└ @ Base loading.jl:1328
...
```

Windowsでは、最初に `set JULIA_DEBUG="loading"` を実行することで `CMD` で同じことを達成でき、`Powershell` では `$env:JULIA_DEBUG="loading"` を使用します。

同様に、環境変数を使用して、`Pkg`のようなモジュールやモジュールのルートのデバッグログを有効にすることができます（[`Base.moduleroot`](@ref)を参照）。すべてのデバッグログを有効にするには、特別な値`all`を使用してください。

REPLからデバッグログをオンにするには、`ENV["JULIA_DEBUG"]`を興味のあるモジュールの名前に設定します。REPLで定義された関数はモジュール`Main`に属しており、これらのログを次のように有効にできます：

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

複数のモジュールのデバッグを有効にするには、カンマ区切りを使用します: `JULIA_DEBUG=loading,Main`。

## Examples

### Example: Writing log events to a file

時には、ログイベントをファイルに書き込むことが有用です。以下は、タスクローカルおよびグローバルロガーを使用して情報をテキストファイルに書き込む方法の例です：

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

ここに、[`ConsoleLogger`](@ref) を作成する例があります。これは、ログレベルが [`Logging.Debug`](@ref) 以上または等しいメッセージを通過させます。

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

イベント処理は、`AbstractLogger` に関連付けられた関数をオーバーライドすることで制御されます：

| Methods to implement                |                        | Brief description                            |
|:----------------------------------- |:---------------------- |:-------------------------------------------- |
| [`Logging.handle_message`](@ref)    |                        | Handle a log event                           |
| [`Logging.shouldlog`](@ref)         |                        | Early filtering of events                    |
| [`Logging.min_enabled_level`](@ref) |                        | Lower bound for log level of accepted events |
| **Optional methods**                | **Default definition** | **Brief description**                        |
| [`Logging.catch_exceptions`](@ref)  | `true`                 | Catch exceptions during event evaluation     |

```@docs
Logging.AbstractLogger
Logging.handle_message
Logging.shouldlog
Logging.min_enabled_level
Logging.catch_exceptions
Logging.disable_logging
```

### Using Loggers

ロガーのインストールと検査：

```@docs
Logging.global_logger
Logging.with_logger
Logging.current_logger
```

システムに供給されるロガー：

```@docs
Logging.NullLogger
Logging.ConsoleLogger
Logging.SimpleLogger
```
