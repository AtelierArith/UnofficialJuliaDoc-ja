```julia
IdentityUnitRange(range::AbstractUnitRange)
```

Represent an AbstractUnitRange `range` as an offset vector such that `range[i] == i`.

`IdentityUnitRange`s are frequently used as axes for offset arrays.
