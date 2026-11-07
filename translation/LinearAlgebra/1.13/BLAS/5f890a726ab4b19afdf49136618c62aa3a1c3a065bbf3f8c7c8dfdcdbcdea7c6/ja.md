```julia
herk!(uplo, trans, alpha, A, beta, C)
```

複素数配列専用のメソッドです。[`trans`](@ref stdlib-blas-trans)に従って、エルミート行列`C`を`alpha*A*A' + beta*C`または`alpha*A'*A + beta*C`としてランクk更新します。`C`のうち、[`uplo`](@ref stdlib-blas-uplo)三角部分のみが更新されます。`C`を返します。
