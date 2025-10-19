```julia
time_ns() -> UInt64
```

Get the time in nanoseconds relative to some machine-specific arbitrary time in the past. The primary use is for measuring elapsed times during program execution. The return value is guaranteed to be monotonic (mod 2⁶⁴) while the system is running, and is unaffected by clock drift or changes to local calendar time, but it may change arbitrarily across system reboots or suspensions.

(Although the returned time is always in nanoseconds, the timing resolution is platform-dependent.)
