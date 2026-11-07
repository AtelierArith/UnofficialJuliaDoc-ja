```julia
ConsiderCountingSort(counting=CountingSort(), next) isa Base.Sort.Algorithm
```

If the input's range is small enough, use the `counting` algorithm. Otherwise, dispatch to the `next` algorithm.

For most types, the threshold is if the range is shorter than half the length, but for types larger than Int64, bitshifts are expensive and RadixSort is not viable, so the threshold is much more generous.
