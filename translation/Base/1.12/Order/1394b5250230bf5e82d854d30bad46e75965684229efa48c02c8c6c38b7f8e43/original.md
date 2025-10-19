```julia
Perm(order::Ordering, data::AbstractVector)
```

`Ordering` on the indices of `data` where `i` is less than `j` if `data[i]` is less than `data[j]` according to `order`. In the case that `data[i]` and `data[j]` are equal, `i` and `j` are compared by numeric value.
