```julia
struct TermInfoRaw
```

特定の機能に関する知識を持たず、`term(5)` のみに基づいて terminfo ファイルを構造化して表現したものです。

!!! warning



これは公開 API の一部ではないため、予告なく変更される場合があります。

# Fields

  * `names::Vector{String}`: この端末が知られている名前。
  * `flags::BitVector`: 0～44 個のフラグ値のリスト。
  * `numbers::Union{Vector{Int16}, Vector{Int32}}`: 0～39 個の数値のリスト。値 `typemax(eltype(numbers))` は、未指定の機能をスキップしつつ、値のインデックスを正しく保つために使用されます。
  * `strings::Vector{Union{String, Nothing}}`: 0～414 個の文字列値のリスト。値 `nothing` は、未指定の機能をスキップしつつ、値のインデックスを正しく保つために使用されます。
  * `extended::Union{Nothing, Dict{Symbol, Union{Bool, Int, String}}}`: 拡張情報セクションが存在する場合は、その全体を辞書として格納します。存在しない場合は `nothing` です。

関連項目: `TermInfo` および `TermCapability`。
