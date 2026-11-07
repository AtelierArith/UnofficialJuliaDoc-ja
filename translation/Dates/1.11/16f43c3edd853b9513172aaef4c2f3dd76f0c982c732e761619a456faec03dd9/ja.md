```julia
tofirst(dt::TimeType, dow::Int; of=Month)::TimeType
```

`dt`を、その月の最初の`dow`に調整します。あるいは、`of=Year`を、その年の最初の`dow`に調整します。
