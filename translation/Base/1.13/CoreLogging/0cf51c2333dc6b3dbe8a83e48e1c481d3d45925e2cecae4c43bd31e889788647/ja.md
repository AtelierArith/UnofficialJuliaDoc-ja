```julia
@debug message  [key=value | value ...]
@info  message  [key=value | value ...]
@warn  message  [key=value | value ...]
@error message  [key=value | value ...]

@logmsg level message [key=value | value ...]
```

情報レベルのログレコードを作成するには、`message`を指定します。利便性のため、標準の重大度レベルである`Debug`、`Info`、`Warn`、`Error`でログを記録する4つのマクロ、`@debug`、`@info`、`@warn`、`@error`が定義されています。`@logmsg`を使うと、`level`を任意の`LogLevel`またはカスタムのログレベル型に、プログラムから設定できます。

`message`には、ログイベントを人が読める形で説明する文字列を返す式を指定します。慣例として、この文字列は表示時にMarkdown形式で整形されます。

省略可能な`key=value`のペアのリストを使うと、任意のユーザー定義メタデータをログレコードの一部としてロギングバックエンドに渡せます。`value`式だけを指定した場合は、[`Symbol`](@ref)を使って、その式を表すキーが生成されます。たとえば、`x`は`x=x`に、`foo(10)`は`Symbol("foo(10)")=foo(10)`になります。キーと値のペアのリストをスプラットするには、通常のスプラット構文`@info "blah" kws...`を使います。

自動生成されるログデータを上書きできるキーもあります。

  * `_module=mod`を使うと、メッセージのソース位置から特定されるモジュールとは別のモジュールを指定できます。
  * `_group=symbol`を使うと、メッセージグループを上書きできます（通常はソースファイルのベース名から決定されます）。
  * `_id=symbol`を使うと、自動生成される一意なメッセージ識別子を上書きできます。異なるソース行で生成されたメッセージを厳密に関連付ける必要がある場合に便利です。
  * `_file=string`と`_line=integer`を使うと、ログメッセージの見かけ上のソース位置を上書きできます。

慣例的な意味を持つキーと値のペアもあります。

  * `maxlog=integer`は、メッセージの表示回数を`maxlog`回以下にするよう、バックエンドに伝えるヒントとして使います。
  * `exception=ex`は、例外をログメッセージとともに渡すために使います。多くの場合、`@error`と組み合わせます。関連するバックトレース`bt`は、タプル`exception=(ex,bt)`を使って付加できます。

# Examples

```julia
@debug "Verbose debugging information.  Invisible by default"
@info  "An informational message"
@warn  "Something was odd.  You should pay attention"
@error "A non fatal error occurred"

x = 10
@info "Some variables attached to the message" x a=42.0

@debug begin
    sA = sum(A)
    "sum(A) = $sA is an expensive operation, evaluated only when `shouldlog` returns true"
end

for i=1:10000
    @info "With the default backend, you will only see (i = $i) ten times"  maxlog=10
    @debug "Algorithm1" i progress=i/10000
end
```
