```julia
struct TermInfo
```

解析済みの terminfo と、対応する機能情報。

!!! warning



これは公開 API の一部ではないため、予告なく変更される場合があります。

# Fields

  * `names::Vector{String}`: この端末が知られている名前。
  * `flags::Int`: 指定されたフラグの数。
  * `numbers::BitVector`: `TERM_NUMBERS` のうち、どれが指定されたかを示すマスク。
  * `strings::BitVector`: `TERM_STRINGS` のうち、どれが指定されたかを示すマスク。
  * `extensions::Vector{Symbol}`: 拡張機能の変数名のリスト。
  * `capabilities::Dict{Symbol, Union{Bool, Int, String}}`: 機能の値そのもの。

関連項目: `TermInfoRaw` および `TermCapability`。
