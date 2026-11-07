```julia
now(::Type{UTC})::DateTime
```

ユーザーのシステム時刻に対応する UTC/GMT の `DateTime` を返します。その他のタイムゾーンについては、TimeZones.jl パッケージを参照してください。

# Examples

```jldoctest; filter = r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{3})?" => "2023-01-04T10:52:24.864"
julia> now(UTC)
2023-01-04T10:52:24.864
```
