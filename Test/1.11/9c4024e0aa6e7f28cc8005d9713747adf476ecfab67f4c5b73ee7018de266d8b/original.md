```julia
Test.set_rng!(ts::AbstractTestSet, rng::AbstractRNG)::AbstractRNG
```

Set the global random number generator (RNG) associated to the input testset `ts` to `rng`. If no RNG is associated to it, do nothing. In any case, always return the input `rng`.
