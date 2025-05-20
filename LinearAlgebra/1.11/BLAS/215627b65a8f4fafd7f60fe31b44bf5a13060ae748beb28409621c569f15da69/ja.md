```
trsm(side, ul, tA, dA, alpha, A, B)
```

`A*X = alpha*B`の解を返すか、[`side`](@ref stdlib-blas-side)と[`tA`](@ref stdlib-blas-trans)によって決定される他の3つのバリアントのいずれかを返します。`A`の[`ul`](@ref stdlib-blas-uplo)三角形のみが使用されます。[`dA`](@ref stdlib-blas-diag)は、対角値が読み取られるか、すべて1であると見なされるかを決定します。
