```julia
TermInfo(raw::TermInfoRaw)
```

既知の端末機能（NCurses 6.3 時点。`TERM_FLAGS`、`TERM_NUMBERS`、`TERM_STRINGS` を参照）を使って、`raw` から `TermInfo` を構築します。
