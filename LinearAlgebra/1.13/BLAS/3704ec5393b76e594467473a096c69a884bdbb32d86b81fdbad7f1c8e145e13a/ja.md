```julia
gemm!(tA, tB, alpha, A, B, beta, C)
```

[`tA`](@ref stdlib-blas-trans)および`tB`に従って、`C`を`alpha*A*B + beta*C`またはその他3つのバリエーションに更新してください。更新後の`C`を返してください。
