```julia
CheckSorted(next) isa Base.Sort.Algorithm
```

Check if the input is already sorted and for large inputs, also check if it is reverse-sorted. The reverse-sorted check is unstable.
