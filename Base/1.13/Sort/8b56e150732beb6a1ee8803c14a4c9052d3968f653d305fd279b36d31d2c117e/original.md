```julia
MergeSort
```

Indicate that a sorting function should use the merge sort algorithm. Merge sort divides the collection into subcollections and repeatedly merges them, sorting each subcollection at each step, until the entire collection has been recombined in sorted form.

Characteristics:

  * *stable*: preserves the ordering of elements that compare equal (e.g. "a" and "A" in a sort of letters that ignores case).
  * *not in-place* in memory.
  * *divide-and-conquer* sort strategy.
  * *good performance* for large collections but typically not quite as fast as [`QuickSort`](@ref).
