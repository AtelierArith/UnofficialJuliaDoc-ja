```
tolast(dt::TimeType, dow::Int; of=Month) -> TimeType
```

`dt`をその月の最後の`dow`に調整します。あるいは、`of=Year`を指定すると、年の最後の`dow`に調整されます。
