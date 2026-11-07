```julia
RadixSort() isa Base.Sort.Algorithm
```

Use the radix sort algorithm.

`RadixSort` is a stable least significant bit first radix sort algorithm that runs in `O(length * log(range))` time and linear space.

It first sorts the entire vector by the last `chunk_size` bits, then by the second to last `chunk_size` bits, and so on. Stability means that it will not reorder two elements that compare equal. This is essential so that the order introduced by earlier, less significant passes is preserved by later passes.

Each pass divides the input into `2^chunk_size == mask+1` buckets. To do this, it

  * counts the number of entries that fall into each bucket
  * uses those counts to compute the indices to move elements of those buckets into
  * moves elements into the computed indices in the swap array
  * switches the swap and working array

`chunk_size` is larger for larger inputs and determined by an empirical heuristic.
