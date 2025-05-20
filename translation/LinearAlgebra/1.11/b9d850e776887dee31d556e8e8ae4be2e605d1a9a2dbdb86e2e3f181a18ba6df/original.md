```
QRCompactWY <: Factorization
```

A QR matrix factorization stored in a compact blocked format, typically obtained from [`qr`](@ref). If $A$ is an `m`×`n` matrix, then

$$
A = Q R
$$

where $Q$ is an orthogonal/unitary matrix and $R$ is upper triangular. It is similar to the [`QR`](@ref) format except that the orthogonal/unitary matrix $Q$ is stored in *Compact WY* format [^Schreiber1989].  For the block size $n_b$, it is stored as a `m`×`n` lower trapezoidal matrix $V$ and a matrix $T = (T_1 \; T_2 \; ... \; T_{b-1} \; T_b')$ composed of $b = \lceil \min(m,n) / n_b \rceil$ upper triangular matrices $T_j$ of size $n_b$×$n_b$ ($j = 1, ..., b-1$) and an upper trapezoidal $n_b$×$\min(m,n) - (b-1) n_b$ matrix $T_b'$ ($j=b$) whose upper square part denoted with $T_b$ satisfying

$$
Q = \prod_{i=1}^{\min(m,n)} (I - \tau_i v_i v_i^T)
= \prod_{j=1}^{b} (I - V_j T_j V_j^T)
$$

such that $v_i$ is the $i$th column of $V$, $\tau_i$ is the $i$th element of `[diag(T_1); diag(T_2); …; diag(T_b)]`, and $(V_1 \; V_2 \; ... \; V_b)$ is the left `m`×`min(m, n)` block of $V$.  When constructed using [`qr`](@ref), the block size is given by $n_b = \min(m, n, 36)$.

Iterating the decomposition produces the components `Q` and `R`.

The object has two fields:

  * `factors`, as in the [`QR`](@ref) type, is an `m`×`n` matrix.

      * The upper triangular part contains the elements of $R$, that is `R = triu(F.factors)` for a `QR` object `F`.
      * The subdiagonal part contains the reflectors $v_i$ stored in a packed format such that `V = I + tril(F.factors, -1)`.
  * `T` is a $n_b$-by-$\min(m,n)$ matrix as described above. The subdiagonal elements for each triangular matrix $T_j$ are ignored.

!!! note
    This format should not to be confused with the older *WY* representation [^Bischof1987].


[^Bischof1987]: C Bischof and C Van Loan, "The WY representation for products of Householder matrices", SIAM J Sci Stat Comput 8 (1987), s2-s13. [doi:10.1137/0908009](https://doi.org/10.1137/0908009)

[^Schreiber1989]: R Schreiber and C Van Loan, "A storage-efficient WY representation for products of Householder transformations", SIAM J Sci Stat Comput 10 (1989), 53-57. [doi:10.1137/0910005](https://doi.org/10.1137/0910005)
