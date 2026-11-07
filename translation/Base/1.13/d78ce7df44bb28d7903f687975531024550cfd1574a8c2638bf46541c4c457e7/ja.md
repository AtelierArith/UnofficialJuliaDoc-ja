```julia
struct TermCapability
```

単一の端末機能の仕様。

!!! warning



これは公開 API の一部ではないため、予告なく変更される場合があります。

# Fields

  * `name::Symbol`: terminfo 機能変数の名前
  * `capname::Symbol`: 機能の *Cap-name*
  * `description::String`: 機能の目的の説明

関連項目: `TermInfo`、`TERM_FLAGS`、`TERM_NUMBERS`、`TERM_STRINGS`。
