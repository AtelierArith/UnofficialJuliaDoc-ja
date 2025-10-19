```julia
floorceil(dt::TimeType, p::Period) -> (TimeType, TimeType)
```

解像度 `p` で `Date` または `DateTime` の `floor` と `ceil` を同時に返します。個別に `floor` と `ceil` を呼び出すよりも効率的です。
