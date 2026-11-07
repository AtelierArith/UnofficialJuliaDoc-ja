```julia
# Parse a single expression/statement
parsestmt(TreeType, text, [index];
          version=VERSION,
          ignore_trivia=true,
          filename=nothing,
          ignore_errors=false,
          ignore_warnings=ignore_errors)

# Parse all statements at top level (file scope)
parseall(...)

# Parse a single syntax atom
parseatom(...)
```

Juliaのソースコード文字列`text`を、型`TreeType`のデータ構造にパースします。`parsestmt`はJuliaの単一の文を、`parseall`はファイルスコープのトップレベル文を、`parseatom`は単一のJulia識別子またはその他の「構文アトム」をパースします。

`text`を`index`なしで渡すと、入力テキスト全体が消費され、ツリー構造のデータが返されます。整数のバイト`index`を渡すと、パースを再開するための`text`内の次のインデックスを含むタプル`(tree, next_index)`が返されます。デフォルトでは、有効なコードの前後にある空白とコメントは無視されますが、`ignore_trivia=false`を設定すると、この動作を無効にできます。

`version`（デフォルトは`VERSION`）を使うと、構文バージョンを任意のJuliaバージョン`>= v"1.0"`に設定できます。v"1.0"以降に追加されたJuliaの構文をすべてパースすることを目指しており、指定された`version`と互換性がない場合はエラーを出力します。

`filename`を渡すと、該当する場合、出力ツリーに埋め込まれるファイル名情報を設定できます。これにより、エラーや警告にもソースファイル名が付加されます。

パース中にエラーまたは警告が発生すると、`ParseError`がスローされます。警告による例外を避けるには、`ignore_warnings=true`を使用してください。エラーによる例外も避けるには、`ignore_errors=true`を使用してください。
