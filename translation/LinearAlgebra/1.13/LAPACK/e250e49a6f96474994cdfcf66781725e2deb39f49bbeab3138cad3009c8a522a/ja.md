```julia
ormlq!(side, trans, A, tau, C)
```

`gelqf!`を用いて計算した`A`の`LQ`分解から`Q`を使って、`side = L`に対する`Q * C`（`trans = N`）、`transpose(Q) * C`（`trans = T`）、`adjoint(Q) * C`（`trans = C`）を計算します。または、`side = R`に対する同等の右側乗算を計算します。`C`は上書きされます。
