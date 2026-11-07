```julia
ConsiderRadixSort(radix=RadixSort(), next) isa Base.Sort.Algorithm
```

If the number of bits in the input's range is small enough and the input supports efficient bitshifts, use the `radix` algorithm. Otherwise, dispatch to the `next` algorithm.
