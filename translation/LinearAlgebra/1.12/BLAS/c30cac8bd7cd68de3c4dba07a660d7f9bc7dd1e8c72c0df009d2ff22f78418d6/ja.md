```julia
trsv(ul, tA, dA, A, b)
```

`A*x = b` の解、または [`tA`](@ref stdlib-blas-trans) と [`ul`](@ref stdlib-blas-uplo) によって決定される他の2つのバリアントのいずれかを返します。 [`dA`](@ref stdlib-blas-diag) は、対角値が読み取られるか、すべてが1であると仮定されるかを決定します。
