```julia
path(trie, h, copyf)::(found, present, trie, i, top, level)
```

Internal function that walks a HAMT and finds the slot for hash. Returns if a value is `present` and a value is `found`.

It returns the `trie` and the index `i` into `trie.data`, as well as the current `level`.

If a copy function is provided `copyf` use the return `top` for the new persistent tree.
