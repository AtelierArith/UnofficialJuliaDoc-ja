```julia
syr2k!(uplo, trans, alpha, A, B, beta, C)
```

[`trans`](@ref stdlib-blas-trans)に従って、対称行列`C`を`alpha*A*transpose(B) + alpha*B*transpose(A) + beta*C`または`alpha*transpose(A)*B + alpha*transpose(B)*A + beta*C`としてランク2k更新します。`C`のうち、[`uplo`](@ref stdlib-blas-uplo)の三角部分のみを使用します。`C`を返します。
