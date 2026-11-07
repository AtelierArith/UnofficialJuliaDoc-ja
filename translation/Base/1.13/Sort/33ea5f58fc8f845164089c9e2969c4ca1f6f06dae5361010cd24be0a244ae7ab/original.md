```julia
CountingSort() isa Base.Sort.Algorithm
```

Use the counting sort algorithm.

`CountingSort` is an algorithm for sorting integers that runs in Θ(length + range) time and space. It counts the number of occurrences of each value in the input and then iterates through those counts repopulating the input with the values in sorted order.
