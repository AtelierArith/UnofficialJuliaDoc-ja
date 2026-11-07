```julia
syrk!(uplo, trans, alpha, A, beta, C)
```

[`trans`](@ref stdlib-blas-trans)に従って、対称行列`C`を`alpha*A*transpose(A) + beta*C`または`alpha*transpose(A)*A + beta*C`としてランクk更新します。`C`では、[`uplo`](@ref stdlib-blas-uplo)側の三角部分のみを使用します。`C`を返します。
