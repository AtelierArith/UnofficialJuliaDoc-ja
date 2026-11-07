```julia
tolast(dt::TimeType, dow::Int; of=Month)::TimeType
```

`dt`を、その月の最後の`dow`に調整します。あるいは、`of=Year`を、その年の最後の`dow`に調整します。
