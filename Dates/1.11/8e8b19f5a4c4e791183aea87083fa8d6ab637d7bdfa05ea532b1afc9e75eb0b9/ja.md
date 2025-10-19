```julia
datetime2unix(dt::DateTime) -> Float64
```

与えられた `DateTime` を取得し、unixエポック `1970-01-01T00:00:00` からの秒数を [`Float64`](@ref) として返します。
