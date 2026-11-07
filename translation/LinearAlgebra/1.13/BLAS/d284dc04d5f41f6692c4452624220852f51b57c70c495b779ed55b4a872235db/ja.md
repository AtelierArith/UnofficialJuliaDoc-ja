```julia
trsm!(side, ul, tA, dA, alpha, A, B)
```

`B`を、`A*X = alpha*B`の解、または[`side`](@ref stdlib-blas-side)と[`tA`](@ref stdlib-blas-trans)によって決まる他の3つのバリアントのいずれかで上書きします。`A`のうち、[`ul`](@ref stdlib-blas-uplo)の三角部分のみが使用されます。[`dA`](@ref stdlib-blas-diag)は、対角要素の値を読み取るか、すべて1とみなすかを指定します。更新された`B`を返します。
