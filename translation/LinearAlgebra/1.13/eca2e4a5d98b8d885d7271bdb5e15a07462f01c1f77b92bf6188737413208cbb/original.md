```julia
_MulAddMul_nonzeroalpha(_add::MulAddMul[, ::Val{false}])
```

Return a new `MulAddMul` with the value of `alpha` potentially set to a literal non-zero value if permitted by the type (e.g., for `_add.alpha isa Bool`, in which case the `alpha` is set to `true` in the returned instance). In other cases, the single-argument call is a no-op and returns `_add` without modifications.

In addition, if `Val(false)` is provided as the second argument, `beta` is set to `false` in the returned `MulAddMul` instance.
