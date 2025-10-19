```julia
tofirst(dt::TimeType, dow::Int; of=Month) -> TimeType
```

Adjusts `dt` to the first `dow` of its month. Alternatively, `of=Year` will adjust to the first `dow` of the year.
