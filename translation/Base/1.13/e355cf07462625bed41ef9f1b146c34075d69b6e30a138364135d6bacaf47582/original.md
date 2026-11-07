```julia
CyclePadding(padding, total_size)
```

Cycles an iterator of `Padding` structs, restarting the padding at `total_size`. E.g. if `padding` is all the padding in a struct and `total_size` is the total aligned size of that array, `CyclePadding` will correspond to the padding in an infinite vector of such structs.
