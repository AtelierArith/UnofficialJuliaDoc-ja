```julia
ScratchQuickSort(next::Base.Sort.Algorithm=Base.Sort.SMALL_ALGORITHM) isa Base.Sort.Algorithm
ScratchQuickSort(lo::Union{Integer, Missing}, hi::Union{Integer, Missing}=lo, next::Base.Sort.Algorithm=Base.Sort.SMALL_ALGORITHM) isa Base.Sort.Algorithm
```

Use the `ScratchQuickSort` algorithm with the `next` algorithm as a base case.

`ScratchQuickSort` is like `QuickSort`, but utilizes scratch space to operate faster and allow for the possibility of maintaining stability.

If `lo` and `hi` are provided, finds and sorts the elements in the range `lo:hi`, reordering but not necessarily sorting other elements in the process. If `lo` or `hi` is `missing`, it is treated as the first or last index of the input, respectively.

`lo` and `hi` may be specified together as an `AbstractUnitRange`.

Characteristics:

  * *stable*: preserves the ordering of elements that compare equal (e.g. "a" and "A" in a sort of letters that ignores case).
  * *not in-place* in memory.
  * *divide-and-conquer*: sort strategy similar to [`QuickSort`](@ref).
  * *linear runtime* if `length(lo:hi)` is constant
  * *quadratic worst case runtime* in pathological cases

(vanishingly rare for non-malicious input)
