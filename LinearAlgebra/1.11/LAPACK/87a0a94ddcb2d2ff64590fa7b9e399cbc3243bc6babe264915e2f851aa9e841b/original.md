```
gttrf!(dl, d, du) -> (dl, d, du, du2, ipiv)
```

Finds the `LU` factorization of a tridiagonal matrix with `dl` on the subdiagonal, `d` on the diagonal, and `du` on the superdiagonal.

Modifies `dl`, `d`, and `du` in-place and returns them and the second superdiagonal `du2` and the pivoting vector `ipiv`.
