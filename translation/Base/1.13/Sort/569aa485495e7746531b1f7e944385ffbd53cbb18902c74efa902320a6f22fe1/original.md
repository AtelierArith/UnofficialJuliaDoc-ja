```julia
IsUIntMappable(yes, no) isa Base.Sort.Algorithm
```

Determines if the elements of a vector can be mapped to unsigned integers while preserving their order under the specified ordering.

If they can be, dispatch to the `yes` algorithm and record the unsigned integer type that the elements may be mapped to. Otherwise dispatch to the `no` algorithm.
