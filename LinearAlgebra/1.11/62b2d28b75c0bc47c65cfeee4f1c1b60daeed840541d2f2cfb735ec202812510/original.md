```
HessenbergQ <: AbstractQ
```

Given a [`Hessenberg`](@ref) factorization object `F`, `F.Q` returns a `HessenbergQ` object, which is an implicit representation of the unitary matrix `Q` in the Hessenberg factorization `QHQ'` represented by `F`. This `F.Q` object can be efficiently multiplied by matrices or vectors, and can be converted to an ordinary matrix type with `Matrix(F.Q)`.
