```julia
rand_ptls(max::UInt32)
```

Return a random UInt32 in the range `0:max-1` using the thread-local RNG state. Max must be greater than 0.
