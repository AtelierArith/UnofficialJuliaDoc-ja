`guardseed(f, seed)` is equivalent to running `Random.seed!(seed); f()` and then restoring the state of the global RNG as it was before.
