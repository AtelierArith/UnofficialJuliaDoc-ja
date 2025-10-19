```julia
tolast(dt::TimeType, dow::Int; of=Month) -> TimeType
```

Adjusts `dt` to the last `dow` of its month. Alternatively, `of=Year` will adjust to the last `dow` of the year.
