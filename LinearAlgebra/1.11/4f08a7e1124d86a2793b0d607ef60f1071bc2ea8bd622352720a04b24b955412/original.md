```
copy_similar(A, T)
```

Copy `A` to a mutable array with eltype `T` based on `similar(A, T, size(A))`.

Compared to `copymutable_oftype`, the result can be more flexible. In general, the type of the output corresponds to that of the three-argument method `similar(A, T, size(A))`.

See also: `copymutable_oftype`.
