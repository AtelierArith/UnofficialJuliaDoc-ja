```
syr2k(uplo, trans, A, B)
```

[`uplo`](@ref stdlib-blas-uplo) の三角行列を返します `A*transpose(B) + B*transpose(A)` または `transpose(A)*B + transpose(B)*A`、[`trans`](@ref stdlib-blas-trans) に従って。
