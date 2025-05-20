```
annotation_events(string::AbstractString, annots::Vector{@NamedTuple{region::UnitRange{Int}, label::Symbol, value::Any}}, subregion::UnitRange{Int})
annotation_events(string::AnnotatedString, subregion::UnitRange{Int})
```

`string`に関して、`annots`の`subregion`内で発生するすべてのアノテーション「変更イベント」を見つけます。`string`がスタイル設定されている場合、`annots`は推測されます。

各変更イベントは、`@NamedTuple{pos::Int, active::Bool, index::Int}`の形式で与えられ、`pos`はイベントの位置、`active`はアノテーションがアクティブ化されているか非アクティブ化されているかを示すブール値、`index`は問題のアノテーションのインデックスです。
