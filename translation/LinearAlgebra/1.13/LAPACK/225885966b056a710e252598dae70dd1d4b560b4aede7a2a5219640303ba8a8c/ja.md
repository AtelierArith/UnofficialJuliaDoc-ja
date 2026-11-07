```julia
gges3!(jobvsl, jobvsr, A, B) -> (A, B, alpha, beta, vsl, vsr)
```

ブロック化アルゴリズムを使用して、`A` と `B` の一般化固有値、一般化シュール形式、左シュールベクトル（`jobsvl = V`）、または右シュールベクトル（`jobvsr = V`）を計算します。この関数には LAPACK 3.6.0 が必要です。

一般化固有値は `alpha` と `beta` に返されます。左シュールベクトルは `vsl` に、右シュールベクトルは `vsr` に返されます。
