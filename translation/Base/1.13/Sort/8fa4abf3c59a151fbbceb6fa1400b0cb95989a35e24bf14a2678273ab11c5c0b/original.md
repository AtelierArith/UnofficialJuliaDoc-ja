```julia
StableCheckSorted(next) isa Base.Sort.Algorithm
```

Check if an input is sorted and/or reverse-sorted.

The definition of reverse-sorted is that for every pair of adjacent elements, the latter is less than the former. This is stricter than `issorted(v, Reverse(o))` to avoid swapping pairs of elements that compare equal.
