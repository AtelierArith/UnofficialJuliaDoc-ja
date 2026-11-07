```julia
calc_jump(steps::Integer)
```

Compute the dSFMT jump polynomial for `steps` steps (by default for the Mersenne-Twister with exponent 19937). Note that `steps` should be less than the period (e.g. ``steps ≪ 2^19937-1``).
