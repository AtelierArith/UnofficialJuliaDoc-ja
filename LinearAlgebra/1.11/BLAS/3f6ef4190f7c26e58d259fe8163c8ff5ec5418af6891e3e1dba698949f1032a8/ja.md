```
gemm!(tA, tB, alpha, A, B, beta, C)
```

`C`を`alpha*A*B + beta*C`または[`tA`](@ref stdlib-blas-trans)と`tB`に応じた他の3つのバリアントに従って更新します。更新された`C`を返します。
