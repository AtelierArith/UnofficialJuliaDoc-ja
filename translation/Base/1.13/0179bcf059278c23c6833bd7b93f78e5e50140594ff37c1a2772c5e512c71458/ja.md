```julia
annotation_events(string::AbstractString, annots::Vector{@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}}, subregion::UnitRange{Int})
annotation_events(string::AnnotatedString, subregion::UnitRange{Int})
```

`string`に関して、`annots`の`subregion`内で発生する注釈の「変更イベント」をすべて検索します。`string`がスタイル設定されると、`annots`が推論されます。

各変更イベントは`@NamedTuple{pos::Int, active::Bool, index::Int}`の形式で与えられます。`pos`はイベントの位置、`active`は注釈が有効化されるか無効化されるかを示すブール値、`index`は対象となる注釈のインデックスです。
