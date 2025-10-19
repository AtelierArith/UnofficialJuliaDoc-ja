```julia
Hessenberg <: Factorization
```

`Hessenberg`オブジェクトは、正方行列のHessenberg因子分解`QHQ'`、またはそのシフト`Q(H+μI)Q'`を表し、これは[`hessenberg`](@ref)関数によって生成されます。
