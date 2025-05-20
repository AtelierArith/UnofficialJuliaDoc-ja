```
floorceil(x::Period, precision::T) where T <: Union{TimePeriod, Week, Day} -> (T, T)
```

`Period`の`p`での`floor`と`ceil`を同時に返します。`floor`と`ceil`を個別に呼び出すよりも効率的です。
