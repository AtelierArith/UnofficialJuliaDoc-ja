```julia
host_triplet()
```

Build host triplet out of `Sys.MACHINE` and various introspective utilities that detect compiler ABI values such as `libgfortran_version`, `libstdcxx_version` and `cxxstring_abi`.  We do this without using any `Platform` tech as it must run before we have much of that built.
