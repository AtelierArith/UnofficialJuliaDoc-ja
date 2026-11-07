```julia
ComputeExtrema(next) isa Base.Sort.Algorithm
```

Compute the extrema of the input under the provided order.

If the minimum is no less than the maximum, then the input is already sorted. Otherwise, dispatch to the `next` algorithm.
