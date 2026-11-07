```julia
condskeel(M, [x, p::Real=Inf])
```

```math
\kappa_S(M, p) = \left\Vert \left\vert M \right\vert \left\vert M^{-1} \right\vert \right\Vert_p \\
\kappa_S(M, x, p) = \frac{\left\Vert \left\vert M \right\vert \left\vert M^{-1} \right\vert \left\vert x \right\vert \right\Vert_p}{\left \Vert x \right \Vert_p}
```

行列 `M` の Skeel 条件数 ``\kappa_S``。必要に応じてベクトル `x` に関する条件数も、作用素 `p` ノルムを用いて計算します。``\left\vert M \right\vert`` は ``M`` の各要素の絶対値からなる行列を表します。``\left\vert M \right\vert_{ij} = \left\vert M_{ij} \right\vert``。`p` に指定できる値は、`1`、`2`、`Inf`（デフォルト）です。

この量は、文献では Bauer 条件数、相対条件数、または成分ごとの相対条件数とも呼ばれます。
