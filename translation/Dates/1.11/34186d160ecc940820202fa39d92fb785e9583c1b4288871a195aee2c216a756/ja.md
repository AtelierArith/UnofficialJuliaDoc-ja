```
tofirst(dt::TimeType, dow::Int; of=Month) -> TimeType
```

`dt`をその月の最初の`dow`に調整します。あるいは、`of=Year`を指定すると、その年の最初の`dow`に調整されます。
