```julia
ormlq!(side, trans, A, tau, C)
```

`gelqf!`を用いて計算した`A`の`LQ`分解から、`side = L`に対する`Q * C`（`trans = N`）、`transpose(Q) * C`（`trans = T`）、`adjoint(Q) * C`（`trans = C`）、または`side = R`に対する同等の右乗算を、`Q`を用いて計算します。`C`は上書きされます。
