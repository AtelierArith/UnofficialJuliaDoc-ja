```julia
floorceil(dt::TimeType, p::Period) -> (TimeType, TimeType)
```

解像度`p`で、`Date`または`DateTime`の`floor`と`ceil`を同時に返します。`floor`と`ceil`を個別に呼び出すより効率的です。
