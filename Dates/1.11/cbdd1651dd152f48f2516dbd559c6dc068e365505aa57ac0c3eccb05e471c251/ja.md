```julia
datetime2unix(dt::DateTime)::Float64
```

指定された`DateTime`を受け取り、Unixエポックからの経過秒数`1970-01-01T00:00:00`を[`Float64`](@ref)として返します。
