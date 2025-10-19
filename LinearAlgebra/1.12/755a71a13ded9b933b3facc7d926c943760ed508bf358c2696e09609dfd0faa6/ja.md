```julia
schur!(A::StridedMatrix, B::StridedMatrix) -> F::GeneralizedSchur
```

[`schur`](@ref) と同様ですが、入力行列 `A` と `B` を作業領域として使用します。
