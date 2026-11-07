```julia
ormrq!(side, trans, A, tau, C)
```

`gerqf!`を用いて計算した`A`の`RQ`分解から、`side = L`に対する`Q * C`（`trans = N`）、`transpose(Q) * C`（`trans = T`）、`adjoint(Q) * C`（`trans = C`）を計算します。または、`side = R`に対して、`Q`を用いた同等の右側乗算を計算します。`C`は上書きされます。
