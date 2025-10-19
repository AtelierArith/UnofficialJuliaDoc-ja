```julia
QR <: Factorization
```

A QR matrix factorization stored in a packed format, typically obtained from [`qr`](@ref). If $A$ is an `m`×`n` matrix, then

$$
A = Q R
$$

where $Q$ is an orthogonal/unitary matrix and $R$ is upper triangular. The matrix $Q$ is stored as a sequence of Householder reflectors $v_i$ and coefficients $\tau_i$ where:

$$
Q = \prod_{i=1}^{\min(m,n)} (I - \tau_i v_i v_i^T).
$$

Iterating the decomposition produces the components `Q` and `R`.

The object has two fields:

  * `factors` is an `m`×`n` matrix.

      * The upper triangular part contains the elements of $R$, that is `R = triu(F.factors)` for a `QR` object `F`.
      * The subdiagonal part contains the reflectors $v_i$ stored in a packed format where $v_i$ is the $i$th column of the matrix `V = I + tril(F.factors, -1)`.
  * `τ` is a vector  of length `min(m,n)` containing the coefficients $\tau_i$.
