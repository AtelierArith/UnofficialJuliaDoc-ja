# Julia Syntax Highlighting

`JuliaSyntaxHighlighting`ライブラリは、`JuliaSyntax`と`StyledStrings`を使用してJuliaコードの構文をハイライトするための小さな便利パッケージです。

標準ライブラリおよびより広いエコシステムでの使用を意図しています。

## [Functions](@id stdlib-jsh-api)

```@docs
JuliaSyntaxHighlighting.highlight
JuliaSyntaxHighlighting.highlight!
```

## [Faces](@id stdlib-jsh-faces)

`highlight`/`highlight!` メソッドは、Julia コードにカスタムフェイスを適用することによって機能します。標準ライブラリの一部として、これらのフェイスは `julia_*` という形式の特権フェイス名を使用します。これらは他のパッケージで再利用でき、`faces.toml` 設定でカスタマイズできます。

!!! warning "Unstable faces"
    `JuliaSyntaxHighlighting`で使用される特定の顔は、ポイントリリースで予告なしに変更される可能性があります。構文ハイライトのルールが時間とともに洗練されるにつれて、変更は次第に少なくなるはずです。


現在の顔のセットとそのデフォルト値は次のとおりです：

  * `julia_macro`: マゼンタ
  * `julia_symbol`: マゼンタ
  * `julia_singleton_identifier`: `julia_symbol`から継承します。
  * `julia_type`: 黄色
  * `julia_typedec`: 明るい青
  * `julia_comment`: グレー
  * `julia_string`: 緑
  * `julia_regex`: `julia_string`から継承します。
  * `julia_backslash_literal`: マゼンタ、`julia_string` から継承されます
  * `julia_string_delim`: 明るい緑
  * `julia_cmdstring`: `julia_string`から継承します。
  * `julia_char`: `julia_string`から継承します。
  * `julia_char_delim`: `julia_string_delim` から継承します。
  * `julia_number`: 明るいマゼンタ
  * `julia_bool`: `julia_number` から継承されます。
  * `julia_funcall`: シアン
  * `julia_broadcast`: 明るい青、太字
  * `julia_builtin`: 明るい青
  * `julia_operator`: 青
  * `julia_comparator`: `julia_operator`から継承します。
  * `julia_assignment`: 明るい赤
  * `julia_keyword`: 赤
  * `julia_parentheses`: スタイルなし
  * `julia_unpaired_parentheses`: `julia_error` と `julia_parentheses` から継承します。
  * `julia_error`: 赤い背景
  * `julia_rainbow_paren_1`: 明るい緑、`julia_parentheses`から継承
  * `julia_rainbow_paren_2`: 明るい青、`julia_parentheses`から継承
  * `julia_rainbow_paren_3`: 明るい赤、`julia_parentheses`から継承されます
  * `julia_rainbow_paren_4`: `julia_rainbow_paren_1` から継承しています。
  * `julia_rainbow_paren_5`: `julia_rainbow_paren_2` から継承しています。
  * `julia_rainbow_paren_6`: `julia_rainbow_paren_3` から継承しています。
  * `julia_rainbow_bracket_1`: 青, `julia_parentheses` から継承されます
  * `julia_rainbow_bracket_2`: 明るい*マゼンタ、`julia*parentheses`から継承
  * `julia_rainbow_bracket_3`: `julia_rainbow_bracket_1` から継承しています。
  * `julia_rainbow_bracket_4`: `julia_rainbow_bracket_2`から継承しています。
  * `julia_rainbow_bracket_5`: `julia_rainbow_bracket_1` から継承しています。
  * `julia_rainbow_bracket_6`: `julia_rainbow_bracket_2`から継承しています。
  * `julia_rainbow_curly_1`: 明るい黄色、`julia_parentheses` から継承されます
  * `julia_rainbow_curly_2`: 黄色、`julia_parentheses`から継承しています。
  * `julia_rainbow_curly_3`: `julia_rainbow_curly_1` から継承しています。
  * `julia_rainbow_curly_4`: `julia_rainbow_curly_2` から継承しています。
  * `julia_rainbow_curly_5`: `julia_rainbow_curly_1` から継承しています。
  * `julia_rainbow_curly_6`: `julia_rainbow_curly_2` から継承しています。
