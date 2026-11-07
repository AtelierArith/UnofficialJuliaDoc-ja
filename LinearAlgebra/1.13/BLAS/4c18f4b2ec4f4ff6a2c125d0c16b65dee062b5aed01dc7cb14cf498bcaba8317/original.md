```julia
lbt_forwarded_funcs(config::LBTConfig, lib::LBTLibraryInfo)
```

Given a backing library `lib`, return the list of all functions that are forwarded to that library, as a vector of `String`s.
