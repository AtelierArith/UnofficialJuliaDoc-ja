```julia
v::VarState
```

A special wrapper that represents a local variable of a method being analyzed. This does not participate in the native type system nor the inference lattice, and it thus should be always unwrapped to `v.typ` when performing any type or lattice operations on it. `v.undef` represents undefined-ness of this static parameter. If `true`, it means that the variable *may* be undefined at runtime, otherwise it is guaranteed to be defined. If `v.typ === Bottom` it means that the variable is strictly undefined.
