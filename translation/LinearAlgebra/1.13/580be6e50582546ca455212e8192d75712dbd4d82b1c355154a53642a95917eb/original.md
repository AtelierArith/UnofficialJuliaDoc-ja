```julia
generic_syrk!(C::StridedMatrix{T}, A::StridedVecOrMat{T}, conjugate::Bool, aat::Bool, α, β) where {T<:Number}
```

Computes syrk/herk for generic number types. If `conjugate` is false computes syrk, i.e., ``A transpose(A) α + C β`` if `aat` is true, and ``transpose(A) A α + C β`` otherwise. If `conjugate` is true computes herk, i.e., ``A A' α + C β`` if `aat` is true, and ``A' A α + C β`` otherwise. Only the upper triangular is computed.
