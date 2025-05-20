```
eigen!(A; permute, scale, sortby)
eigen!(A, B; sortby)
```

Same as [`eigen`](@ref), but saves space by overwriting the input `A` (and `B`), instead of creating a copy.
