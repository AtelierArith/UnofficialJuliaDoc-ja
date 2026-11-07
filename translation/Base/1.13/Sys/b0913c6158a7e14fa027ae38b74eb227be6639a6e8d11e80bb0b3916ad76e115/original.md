```julia
Sys.SC_CLK_TCK::Clong
```

The number of system "clock ticks" per second, corresponding to `sysconf(_SC_CLK_TCK)` on POSIX systems, or `0` if it is unknown.
