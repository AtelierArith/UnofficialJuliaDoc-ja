```julia
floorceil(x::Period, precision::T) where T <: Union{TimePeriod, Week, Day} -> (T, T)
```

`Period`の解像度`p`で`floor`と`ceil`を同時に返します。`floor`と`ceil`を個別に呼び出すよりも効率的です。
