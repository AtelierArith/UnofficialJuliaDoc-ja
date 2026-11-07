# Julia Syntax Highlighting

`JuliaSyntaxHighlighting`ライブラリは、`JuliaSyntax`と`StyledStrings`を使ってJuliaコードの構文をハイライトするための、小規模で便利なパッケージです。

標準ライブラリ全体およびより広いエコシステムでの利用を想定しています。

## [Functions](@id stdlib-jsh-api)

```@docs
JuliaSyntaxHighlighting.highlight
JuliaSyntaxHighlighting.highlight!
```

## [Faces](@id stdlib-jsh-faces)

`highlight`/`highlight!`メソッドは、Juliaコードにカスタムフェイスを適用します。標準ライブラリの一部であるため、これらのフェイスには、`julia_*`の形式の特権付きフェイス名が使われます。これらは他のパッケージでも再利用でき、`faces.toml`の設定でカスタマイズできます。

!!! warning "不安定なフェイス"
    `JuliaSyntaxHighlighting`で使われる個々のフェイスは、ポイントリリースで予告なく変更される可能性があります。ただし、構文ハイライトのルールは時間とともに改良されるため、変更の頻度は次第に低くなる見込みです。


現在のフェイスとそのデフォルト値は次のとおりです。

  * `julia_macro`: マゼンタ
  * `julia_symbol`: マゼンタ
  * `julia_singleton_identifier`: `julia_symbol`を継承
  * `julia_type`: 黄色
  * `julia_typedec`: 明るい青
  * `julia_comment`: 灰色
  * `julia_string`: 緑
  * `julia_regex`: `julia_string`を継承
  * `julia_backslash_literal`: マゼンタ。`julia_string`を継承
  * `julia_string_delim`: 明るい緑
  * `julia_cmdstring`: `julia_string`を継承
  * `julia_char`: `julia_string`を継承
  * `julia_char_delim`: `julia_string_delim`を継承
  * `julia_number`: 明るいマゼンタ
  * `julia_bool`: `julia_number`を継承
  * `julia_funcall`: シアン
  * `julia_funcdef`: シアン
  * `julia_broadcast`: 明るい青、太字
  * `julia_builtin`: 明るい青
  * `julia_operator`: 青
  * `julia_comparator`: `julia_operator`を継承
  * `julia_assignment`: 明るい赤
  * `julia_keyword`: 赤
  * `julia_parentheses`: スタイルなし
  * `julia_unpaired_parentheses`: `julia_error`と`julia_parentheses`を継承
  * `julia_error`: 赤い背景
  * `julia_rainbow_paren_1`: 明るい緑。`julia_parentheses`を継承
  * `julia_rainbow_paren_2`: 明るい青。`julia_parentheses`を継承
  * `julia_rainbow_paren_3`: 明るい赤。`julia_parentheses`を継承
  * `julia_rainbow_paren_4`: `julia_rainbow_paren_1`を継承
  * `julia_rainbow_paren_5`: `julia_rainbow_paren_2`を継承
  * `julia_rainbow_paren_6`: `julia_rainbow_paren_3`を継承
  * `julia_rainbow_bracket_1`: 青。`julia_parentheses`を継承
  * `julia_rainbow_bracket_2`: 明るいマゼンタ。`julia*parentheses`を継承
  * `julia_rainbow_bracket_3`: `julia_rainbow_bracket_1`を継承
  * `julia_rainbow_bracket_4`: `julia_rainbow_bracket_2`を継承
  * `julia_rainbow_bracket_5`: `julia_rainbow_bracket_1`を継承
  * `julia_rainbow_bracket_6`: `julia_rainbow_bracket_2`を継承
  * `julia_rainbow_curly_1`: 明るい黄色。`julia_parentheses`を継承
  * `julia_rainbow_curly_2`: 黄色。`julia_parentheses`を継承
  * `julia_rainbow_curly_3`: `julia_rainbow_curly_1`を継承
  * `julia_rainbow_curly_4`: `julia_rainbow_curly_2`を継承
  * `julia_rainbow_curly_5`: `julia_rainbow_curly_1`を継承
  * `julia_rainbow_curly_6`: `julia_rainbow_curly_2`を継承
