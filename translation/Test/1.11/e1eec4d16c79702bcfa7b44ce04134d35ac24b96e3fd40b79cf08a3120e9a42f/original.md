```julia
Test.get_rng(ts::AbstractTestSet)::Union{Nothing,AbstractRNG}
```

Return the global random number generator (RNG) associated to the input testset `ts`. If no RNG is associated to it, return `nothing`.
