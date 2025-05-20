```
trsm!(side, ul, tA, dA, alpha, A, B)
```

`B`を`A*X = alpha*B`の解で上書きするか、[`side`](@ref stdlib-blas-side)と[`tA`](@ref stdlib-blas-trans)によって決定される他の3つのバリアントのいずれかで上書きします。`A`の[`ul`](@ref stdlib-blas-uplo)三角形のみが使用されます。[`dA`](@ref stdlib-blas-diag)は、対角値が読み取られるか、すべて1であると見なされるかを決定します。更新された`B`を返します。
