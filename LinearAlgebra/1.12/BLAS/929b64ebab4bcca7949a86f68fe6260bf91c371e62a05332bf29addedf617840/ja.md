```julia
her2k(uplo, trans, alpha, A, B)
```

[`uplo`](@ref stdlib-blas-uplo) の三角行列を返します `alpha*A*B' + alpha*B*A'` または `alpha*A'*B + alpha*B'*A`、[`trans`](@ref stdlib-blas-trans) に従って。
