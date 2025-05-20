```
trsv!(ul, tA, dA, A, b)
```

`b`を`A*x = b`の解で上書きするか、[`tA`](@ref stdlib-blas-trans)および[`ul`](@ref stdlib-blas-uplo)によって決定される他の2つのバリアントのいずれかで上書きします。[`dA`](@ref stdlib-blas-diag)は対角値が読み取られるか、すべて1であると仮定されるかを決定します。更新された`b`を返します。
