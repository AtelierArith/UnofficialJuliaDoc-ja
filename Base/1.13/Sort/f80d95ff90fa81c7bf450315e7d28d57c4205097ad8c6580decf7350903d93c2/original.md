```julia
Small{N}(small=SMALL_ALGORITHM, big) isa Base.Sort.Algorithm
```

Sort inputs with `length(lo:hi) <= N` using the `small` algorithm. Otherwise use the `big` algorithm.
