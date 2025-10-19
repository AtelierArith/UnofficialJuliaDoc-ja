```julia
gges3!(jobvsl, jobvsr, A, B) -> (A, B, alpha, beta, vsl, vsr)
```

一般化固有値、一般化シュア形式、左シュアベクトル（`jobsvl = V`）、または右シュアベクトル（`jobvsr = V`）をブロックアルゴリズムを使用して `A` と `B` のために計算します。この関数は LAPACK 3.6.0 を必要とします。

一般化固有値は `alpha` と `beta` に返されます。左シュアベクトルは `vsl` に、右シュアベクトルは `vsr` に返されます。
