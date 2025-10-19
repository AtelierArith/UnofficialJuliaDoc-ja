```julia
DateTime(periods::Period...) -> DateTime
```

Construct a `DateTime` type by `Period` type parts. Arguments may be in any order. DateTime parts not provided will default to the value of `Dates.default(period)`.
