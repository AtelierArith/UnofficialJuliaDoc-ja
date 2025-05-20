```
condskeel(M, [x, p::Real=Inf])
```

$$
\kappa_S(M, p) = \left\Vert \left\vert M \right\vert \left\vert M^{-1} \right\vert \right\Vert_p \\
\kappa_S(M, x, p) = \frac{\left\Vert \left\vert M \right\vert \left\vert M^{-1} \right\vert \left\vert x \right\vert \right\Vert_p}{\left \Vert x \right \Vert_p}
$$

Skeel condition number $\kappa_S$ of the matrix `M`, optionally with respect to the vector `x`, as computed using the operator `p`-norm. $\left\vert M \right\vert$ denotes the matrix of (entry wise) absolute values of $M$; $\left\vert M \right\vert_{ij} = \left\vert M_{ij} \right\vert$. Valid values for `p` are `1`, `2` and `Inf` (default).

This quantity is also known in the literature as the Bauer condition number, relative condition number, or componentwise relative condition number.
