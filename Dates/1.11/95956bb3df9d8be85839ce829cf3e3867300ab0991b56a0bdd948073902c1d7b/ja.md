```julia
tolast(dt::TimeType, dow::Int; of=Month) -> TimeType
```

`dt`をその月の最後の`dow`に調整します。あるいは、`of=Year`を指定すると、その年の最後の`dow`に調整されます。
