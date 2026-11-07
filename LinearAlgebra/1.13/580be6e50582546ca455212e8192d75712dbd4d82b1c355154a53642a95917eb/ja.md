```julia
generic_syrk!(C::StridedMatrix{T}, A::StridedVecOrMat{T}, conjugate::Bool, aat::Bool, α, β) where {T<:Number}
```

汎用数値型に対して syrk/herk を計算します。`conjugate` が false の場合は syrk を計算します。つまり、`aat` が true なら ``A transpose(A) α + C β`` を、そうでなければ ``transpose(A) A α + C β`` を計算します。`conjugate` が true の場合は herk を計算します。つまり、`aat` が true なら ``A A' α + C β`` を、そうでなければ ``A' A α + C β`` を計算します。計算されるのは上三角部分のみです。
