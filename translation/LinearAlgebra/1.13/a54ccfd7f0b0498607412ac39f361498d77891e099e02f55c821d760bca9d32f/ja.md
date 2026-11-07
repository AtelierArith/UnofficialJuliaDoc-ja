```julia
schur!(A::StridedMatrix, B::StridedMatrix) -> F::GeneralizedSchur
```

[`schur`](@ref)と同じですが、入力行列`A`および`B`をワークスペースとして使用します。
