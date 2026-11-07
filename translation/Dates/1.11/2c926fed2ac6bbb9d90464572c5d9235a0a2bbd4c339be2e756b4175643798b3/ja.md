```julia
floorceil(dt::TimeType, p::Period) -> (TimeType, TimeType)
```

`Date`または`DateTime`の`floor`と`ceil`を、解像度`p`で同時に返します。`floor`と`ceil`を個別に呼び出すより効率的です。
