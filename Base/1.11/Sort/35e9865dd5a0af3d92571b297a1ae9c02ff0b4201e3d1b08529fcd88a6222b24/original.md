```
PartialQuickSort{T <: Union{Integer,OrdinalRange}}
```

Indicate that a sorting function should use the partial quick sort algorithm. `PartialQuickSort(k)` is like `QuickSort`, but is only required to find and sort the elements that would end up in `v[k]` were `v` fully sorted.

Characteristics:

  * *not stable*: does not preserve the ordering of elements that compare equal (e.g. "a" and "A" in a sort of letters that ignores case).
  * *in-place* in memory.
  * *divide-and-conquer*: sort strategy similar to [`MergeSort`](@ref).

Note that `PartialQuickSort(k)` does not necessarily sort the whole array. For example,

```jldoctest
julia> x = rand(100);

julia> k = 50:100;

julia> s1 = sort(x; alg=QuickSort);

julia> s2 = sort(x; alg=PartialQuickSort(k));

julia> map(issorted, (s1, s2))
(true, false)

julia> map(x->issorted(x[k]), (s1, s2))
(true, true)

julia> s1[k] == s2[k]
true
```
