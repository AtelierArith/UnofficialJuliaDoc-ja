```julia
datetime2epochms(dt::DateTime)::Int64
```

与えられた`DateTime`を受け取り、丸めの基準時刻（`0000-01-01T00:00:00`）からの経過ミリ秒数を[`Int64`](@ref)として返します。
