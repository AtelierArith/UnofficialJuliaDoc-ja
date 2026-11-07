```julia
floorceil(x::Period, precision::T) where T <: Union{TimePeriod, Week, Day} -> (T, T)
```

`Period`を`p`の解像度で処理し、`floor`と`ceil`を同時に返します。`floor`と`ceil`を個別に呼び出すより効率的です。
