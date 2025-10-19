```julia
schur!(A::StridedMatrix, B::StridedMatrix) -> F::GeneralizedSchur
```

Same as [`schur`](@ref) but uses the input matrices `A` and `B` as workspace.
