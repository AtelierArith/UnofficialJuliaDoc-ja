```julia
DateTime
```

`DateTime` represents a point in time according to the proleptic Gregorian calendar. The finest resolution of the time is millisecond (i.e., microseconds or nanoseconds cannot be represented by this type). The type supports fixed-point arithmetic, and thus is prone to underflowing (and overflowing). A notable consequence is rounding when adding a `Microsecond` or a `Nanosecond`:

```jldoctest
julia> dt = DateTime(2023, 8, 19, 17, 45, 32, 900)
2023-08-19T17:45:32.900

julia> dt + Millisecond(1)
2023-08-19T17:45:32.901

julia> dt + Microsecond(1000) # 1000us == 1ms
2023-08-19T17:45:32.901

julia> dt + Microsecond(999) # 999us rounded to 1000us
2023-08-19T17:45:32.901

julia> dt + Microsecond(1499) # 1499 rounded to 1000us
2023-08-19T17:45:32.901
```
