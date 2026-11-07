```julia
struct NotFound end
const NOT_FOUND = NotFound()
```

A special singleton that represents a variable has not been analyzed yet. Particularly, all SSA value types are initialized as `NOT_FOUND` when creating a new `InferenceState`. Note that this is only used for `smerge`, which updates abstract state `VarTable`, and thus we don't define the lattice for this.
