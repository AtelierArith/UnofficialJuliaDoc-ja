```julia
shred!(f::Function, x)
```

Applies function `f` to the argument `x` and then shreds `x`. This function is useful when you need to perform some operations on e.g. a `SecretBuffer` and then want to ensure that it is securely shredded afterwards.
