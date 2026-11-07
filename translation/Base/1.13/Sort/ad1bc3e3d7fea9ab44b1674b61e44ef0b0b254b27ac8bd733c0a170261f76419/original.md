```julia
BracketedSort(target[, next::Algorithm]) isa Base.Sort.Algorithm
```

Perform a partialsort for the elements that fall into the indices specified by the `target` using BracketedSort with the `next` algorithm for subproblems.

BracketedSort takes a random* sample of the input, estimates the quantiles of the input using the quantiles of the sample to find signposts that almost certainly bracket the target values, filters the value in the input that fall between the signpost values to the front of the input, and then, if that "almost certainly" turned out to be true, finds the target within the small chunk that are, by value, between the signposts and now by position, at the front of the vector. On small inputs or when target is close to the size of the input, BracketedSort falls back to the `next` algorithm directly. Otherwise, BracketedSort uses the `next` algorithm only to compute quantiles of the sample and to find the target within the small chunk.

## Performance

If the `next` algorithm has `O(n * log(n))` runtime and the input is not pathological then the runtime of this algorithm is `O(n + k * log(k))` where `n` is the length of the input and `k` is `length(target)`. On pathological inputs the asymptotic runtime is the same as the runtime of the `next` algorithm.

BracketedSort itself does not allocate. If `next` is in-place then BracketedSort is also in-place. If `next` is not in place, and it's space usage increases monotonically with input length then BracketedSort's maximum space usage will never be more than the space usage of `next` on the input BracketedSort receives. For large nonpathological inputs and targets substantially smaller than the size of the input, BracketedSort's maximum memory usage will be much less than `next`'s. If the maximum additional space usage of `next` scales linearly then for small k the average* maximum additional space usage of BracketedSort will be `O(n^(2.3/3))`.

By default, BracketedSort uses the `O(n)` space and `O(n + k log k)` runtime `ScratchQuickSort` algorithm recursively.

*Sorting is unable to depend on Random.jl because Random.jl depends on sorting.  Consequently, we use `hash` as a source of randomness. The average runtime guarantees  assume that `hash(x::Int)` produces a random result. However, as this randomization is  deterministic, if you try hard enough you can find inputs that consistently reach the  worst case bounds. Actually constructing such inputs is an exercise left to the reader.  Have fun :).

Characteristics:

  * *unstable*: does not preserve the ordering of elements that compare equal (e.g. "a" and "A" in a sort of letters that ignores case).
  * *in-place* in memory if the `next` algorithm is in-place.
  * *estimate-and-filter*: strategy
  * *linear runtime* if `length(target)` is constant and `next` is reasonable
  * *n + k log k* worst case runtime if `next` has that runtime.
  * *pathological inputs* can significantly increase constant factors.
