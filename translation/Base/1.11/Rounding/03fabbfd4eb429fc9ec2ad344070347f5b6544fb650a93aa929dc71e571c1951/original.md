```
get_zero_subnormals() -> Bool
```

Return `false` if operations on subnormal floating-point values ("denormals") obey rules for IEEE arithmetic, and `true` if they might be converted to zeros.

!!! warning
    This function only affects the current thread.

