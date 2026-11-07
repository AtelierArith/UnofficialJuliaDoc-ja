```julia
date2epochdays(dt::Date)::Int64
```

指定された`Date`を受け取り、丸めの基準時点（`0000-01-01T00:00:00`）からの日数を[`Int64`](@ref)として返します。
