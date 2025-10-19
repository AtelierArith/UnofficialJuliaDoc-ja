```julia
gges!(jobvsl, jobvsr, A, B) -> (A, B, alpha, beta, vsl, vsr)
```

一般化固有値、一般化シュア形式、左シュアベクトル（`jobsvl = V`）、または右シュアベクトル（`jobvsr = V`）を `A` と `B` のために計算します。

一般化固有値は `alpha` と `beta` に返されます。左シュアベクトルは `vsl` に、右シュアベクトルは `vsr` に返されます。
