```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/Logging/docs/src/index.md"
```

# [Logging](@id man-logging)

[`Logging`](@ref Logging.Logging) モジュールは、計算の履歴や進行状況をイベントのログとして記録する仕組みを提供します。イベントは、ソースコードにログ文を挿入することで作成されます。たとえば、次のように記述します。

```julia
@warn "Abandon printf debugging, all ye who enter here!"
┌ Warning: Abandon printf debugging, all ye who enter here!
└ @ Main REPL[1]:1
```

この仕組みには、ソースコードのあちこちで `println()` を呼び出す方法に比べて、いくつかの利点があります。第1に、ソースコードを編集せずに、メッセージを表示するかどうかや表示方法を制御できます。たとえば、上記の `@warn` とは異なり、次のコードはデフォルトでは何も出力しません。

```julia
@debug "The sum of some values $(sum(rand(100)))"
```

さらに、後で無視されるメッセージは評価されないため、このようなデバッグ文をソースコードに残しておいても、コストはごくわずかです。この例では、デバッグログを有効にしない限り、`sum(rand(100))` も、それに関連する文字列処理も実行されません。

第2に、ログツールを使うと、キーと値のペアの集合として、任意のデータを各イベントに付加できます。これにより、ローカル変数やその他のプログラムの状態を記録し、後で分析できます。たとえば、ローカルの配列変数 `A` と、キー `s` に対応する値としてベクトル `v` の総和を付加するには、次のように記述します。

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

ログマクロ `@debug`、`@info`、`@warn`、`@error` はすべて共通の機能を備えています。これらの機能については、より汎用的なマクロ [`@logmsg`](@ref) のドキュメントで詳しく説明しています。

## Log event structure

各イベントでは複数のデータが生成されます。その一部はユーザーが指定し、残りは自動的に抽出されます。まず、ユーザーが定義するデータを見てみましょう。

  * *ログレベル*は、メッセージを大まかに分類するもので、早期フィルタリングに使われます。[`LogLevel`](@ref) 型にはいくつかの標準レベルがあり、ユーザー独自のレベルを定義することもできます。それぞれの用途は次のように異なります。

      * [`Logging.Debug`](@ref)（ログレベル -1000）は、プログラムの開発者向けの情報です。このレベルのイベントはデフォルトで無効になっています。
      * [`Logging.Info`](@ref)（ログレベル 0）は、ユーザー向けの一般的な情報です。`println` を直接使う代わりになるものと考えてください。
      * [`Logging.Warn`](@ref)（ログレベル 1000）は、何らかの問題があり、おそらく対処が必要ですが、現時点ではプログラムがまだ動作していることを意味します。
      * [`Logging.Error`](@ref)（ログレベル 2000）は、何らかの問題があり、少なくともコードのこの部分では回復が見込めないことを意味します。多くの場合、例外をスローすれば必要な情報をすべて伝えられるため、このログレベルは不要です。
  * *メッセージ*は、イベントを説明するオブジェクトです。慣例として、メッセージとして渡される `AbstractString` は Markdown 形式であるとみなされます。その他の型は、テキスト出力では `print(io, obj)` または `string(obj)` を使って表示されます。また、設定されているロガーが他のマルチメディア表示を使う場合は、`show(io,mime,obj)` が使われることもあります。
  * 省略可能な*キーと値のペア*を使うと、各イベントに任意のデータを付加できます。一部のキーには慣例的な意味があり、イベントの解釈方法に影響することがあります（[`@logmsg`](@ref) を参照）。

システムは、各イベントについて次の標準情報も生成します。

  * ログマクロが展開された `module`。
  * ソースコード内でログマクロが記述されている `file` と `line`。
  * メッセージの `id`。これは、ログマクロが記述されている*ソースコードの文*に対する、一意で固定の識別子です。ログ文自体が変わらない限り、ファイルのソースコードが変更されても、この識別子はできるだけ変わらないように設計されています。
  * イベントの `group`。デフォルトでは、拡張子を除いたファイルのベース名に設定されます。これを使うと、ログレベルよりも細かいカテゴリにメッセージを分類したり（たとえば、非推奨に関する警告はすべてグループ `:depwarn` に属します）、モジュール内やモジュールをまたいで論理的にグループ化したりできます。

イベントの発生時刻など、有用な情報の一部はデフォルトでは含まれないことに注意してください。これは、そのような情報の取得にはコストがかかる可能性があり、また、現在のロガーから*動的に*取得できるためです。[custom logger](@ref AbstractLogger-interface) を定義すれば、時刻、バックトレース、グローバル変数の値など、必要に応じて有用な情報をイベントデータに簡単に追加できます。

## Processing log events

例からわかるように、ログ文には、ログイベントの送信先や処理方法が指定されていません。これは、この仕組みを組み合わせやすくし、並行処理でも自然に使えるようにする重要な設計上の特徴です。そのために、次の2つの関心事を分離しています。

  * ログイベントの*作成*は、モジュールの作成者が担います。作成者は、どこでイベントを発生させ、どの情報を含めるかを決める必要があります。
  * ログイベントの*処理*、つまり表示、フィルタリング、集約、記録は、アプリケーションの作成者が担います。作成者は、複数のモジュールをまとめて、連携して動作するアプリケーションにする必要があります。

### Loggers

イベントの処理は*ロガー*が行います。ロガーは、イベントを最初に受け取る、ユーザーが設定可能なコードです。すべてのロガーは [`AbstractLogger`](@ref) のサブタイプでなければなりません。

イベントが発生すると、まずタスクローカルのロガーを探し、なければグローバルロガーを使うことで、適切なロガーを見つけます。この考え方の背景には、ログイベントの処理方法を把握しているアプリケーションコードは、コールスタックの上位のどこかにある、という前提があります。したがって、ロガーはコールスタックを上にたどって探すべきです。つまり、ロガーは*動的スコープ*を持つべきなのです。（この点は、ロガーが*レキシカルスコープ*を持ち、モジュールの作成者によって明示的に、または単純なグローバル変数として提供されるログフレームワークとは異なります。そのような仕組みでは、複数のモジュールの機能を組み合わせる際にログを制御しづらくなります。）

グローバルロガーは [`global_logger`](@ref) で設定でき、タスクローカルのロガーは [`with_logger`](@ref) で制御できます。新しく生成されたタスクは、親タスクのロガーを継承します。

ライブラリには3種類のロガーが用意されています。[`ConsoleLogger`](@ref) は、REPL の起動時に使われるデフォルトのロガーです。イベントを読みやすいテキスト形式で表示し、書式設定やフィルタリングを簡単かつ使いやすく制御できるようにしています。[`NullLogger`](@ref) は、必要に応じてすべてのメッセージを破棄するための便利な手段で、ログにおける [`devnull`](@ref) ストリームに相当します。[`SimpleLogger`](@ref) は、ごく単純なテキスト形式のロガーで、主にログシステム自体のデバッグに役立ちます。

独自のロガーには、[reference section](@ref AbstractLogger-interface) で説明されている関数のオーバーロードを用意する必要があります。

### Early filtering and message handling

イベントが発生すると、破棄されるメッセージを生成しないように、いくつかの段階で早期フィルタリングが行われます。

1. メッセージのログレベルを、グローバルな最小レベル（[`disable_logging`](@ref) で設定）と照合します。これは大まかな制御ですが、コストがきわめて低いグローバル設定です。
2. 現在のロガーの状態を取得し、[`Logging.min_enabled_level`](@ref) を呼び出して得られる、キャッシュされたロガーの最小レベルとメッセージのレベルを照合します。この動作は環境変数で上書きできます（詳しくは後述します）。
3. 現在のロガーと、静的に計算できる最小限の情報（レベル、モジュール、グループ、ID）を渡して、[`Logging.shouldlog`](@ref) 関数を呼び出します。特に便利なのは、`shouldlog` にイベントの `id` が渡される点です。これを使うと、キャッシュされた述語に基づいてイベントを早い段階で破棄できます。

これらのチェックをすべて通過すると、メッセージとキーと値のペアが完全に評価され、[`Logging.handle_message`](@ref) 関数を通じて現在のロガーに渡されます。`handle_message()` は、必要に応じて追加のフィルタリングを行い、イベントを画面に表示したり、ファイルに保存したりできます。

ログイベントの生成中に発生した例外は、デフォルトでは捕捉され、ログに記録されます。これにより、個々の不正なイベントが原因でアプリケーションがクラッシュするのを防げます。本番環境で、普段はあまり使わないデバッグイベントを有効にするときに役立ちます。この動作は、[`Logging.catch_exceptions`](@ref) を拡張することで、ロガーの型ごとにカスタマイズできます。

## Testing log events

ログイベントは通常のコード実行の副作用ですが、特定の情報メッセージや警告をテストしたい場合もあるでしょう。`Test` モジュールには、ログイベントのストリームに対してパターンマッチングを行うための [`@test_logs`](@ref) マクロが用意されています。

## Environment variables

メッセージのフィルタリングは [`JULIA_DEBUG`](@ref JULIA_DEBUG) 環境変数で調整でき、ファイルやモジュールのデバッグログを簡単に有効にできます。`JULIA_DEBUG=loading` を指定して Julia を起動すると、`loading.jl` 内の `@debug` ログメッセージが有効になります。たとえば、Linux のシェルでは次のようにします。

```
$ JULIA_DEBUG=loading julia -e 'using OhMyREPL'
┌ Debug: Rejecting cache file /home/user/.julia/compiled/v0.7/OhMyREPL.ji due to it containing an incompatible cache header
└ @ Base loading.jl:1328
[ Info: Recompiling stale cache file /home/user/.julia/compiled/v0.7/OhMyREPL.ji for module OhMyREPL
┌ Debug: Rejecting cache file /home/user/.julia/compiled/v0.7/Tokenize.ji due to it containing an incompatible cache header
└ @ Base loading.jl:1328
...
```

Windows では、`CMD` で最初に `set JULIA_DEBUG="loading"` を実行するか、`Powershell` で `$env:JULIA_DEBUG="loading"` を実行することで、同じことができます。

同様に、この環境変数を使って、`Pkg` などのモジュールや、モジュールのルート（[`Base.moduleroot`](@ref) を参照）のデバッグログを有効にできます。すべてのデバッグログを有効にするには、特別な値 `all` を使います。

REPL からデバッグログを有効にするには、`ENV["JULIA_DEBUG"]` に対象のモジュール名を設定します。REPL で定義された関数はモジュール `Main` に属します。これらの関数のログは、次のように有効にできます。

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

複数のモジュールのデバッグログを有効にするには、カンマで区切ります：`JULIA_DEBUG=loading,Main`。

## Examples

### Example: Writing log events to a file

ログイベントをファイルに書き出すと便利な場合があります。次に、タスクローカルのロガーとグローバルロガーを使って、情報をテキストファイルに書き出す例を示します。

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

次に、ログレベルが [`Logging.Debug`](@ref) 以上のメッセージをすべて通す [`ConsoleLogger`](@ref) を作成する例を示します。

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

イベントの処理は、`AbstractLogger` に関連する関数をオーバーライドすることで制御します。

| 実装するメソッド                            |              | 概要                 |
|:----------------------------------- |:------------ |:------------------ |
| [`Logging.handle_message`](@ref)    |              | ログイベントの処理          |
| [`Logging.shouldlog`](@ref)         |              | イベントの早期フィルタリング     |
| [`Logging.min_enabled_level`](@ref) |              | 受け入れるイベントのログレベルの下限 |
| **省略可能なメソッド**                       | **デフォルトの定義** | **概要**             |
| [`Logging.catch_exceptions`](@ref)  | `true`       | イベントの評価中に発生する例外の捕捉 |

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

システムに付属するロガー：

```@docs
Logging.NullLogger
Logging.ConsoleLogger
Logging.SimpleLogger
```
