```julia
condskeel(M, [x, p::Real=Inf])
```

$$
\kappa_S(M, p) = \left\Vert \left\vert M \right\vert \left\vert M^{-1} \right\vert \right\Vert_p \\
\kappa_S(M, x, p) = \frac{\left\Vert \left\vert M \right\vert \left\vert M^{-1} \right\vert \left\vert x \right\vert \right\Vert_p}{\left \Vert x \right \Vert_p}
$$

行列 `M` のスキール条件数 $\kappa_S$ は、ベクトル `x` に関してオプションで、演算子 `p`-ノルムを使用して計算されます。 $\left\vert M \right\vert$ は $M$ の（要素ごとの）絶対値の行列を示し、$\left\vert M \right\vert_{ij} = \left\vert M_{ij} \right\vert$ です。 `p` の有効な値は `1`、`2`、および `Inf`（デフォルト）です。

この量は文献ではバウアー条件数、相対条件数、または成分ごとの相対条件数としても知られています。
