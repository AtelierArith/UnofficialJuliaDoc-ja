```
clear_malloc_data()
```

Clears any stored memory allocation data when running julia with `--track-allocation`. Execute the command(s) you want to test (to force JIT-compilation), then call [`clear_malloc_data`](@ref). Then execute your command(s) again, quit Julia, and examine the resulting `*.mem` files.
