```
trsv(ul, tA, dA, A, b)
```

`A*x = b` の解を返すか、[`tA`](@ref stdlib-blas-trans) と [`ul`](@ref stdlib-blas-uplo) によって決定される他の2つのバリアントのいずれかを返します。[`dA`](@ref stdlib-blas-diag) は対角値が読み取られるか、すべて1であると仮定されるかを決定します。
