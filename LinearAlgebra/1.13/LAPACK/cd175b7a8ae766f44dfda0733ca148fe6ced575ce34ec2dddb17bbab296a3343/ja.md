```julia
lacpy!(B, A, uplo) -> B
```

行列 `A` の全部または一部を、別の行列 `B` にコピーします。uplo は、コピー元の行列 `A` のどの部分をコピー先の行列 `B` にコピーするかを指定します。下三角部分には `uplo = 'L'`、上三角部分には `uplo = 'U'` を指定し、行列 `A` 全体をコピーする場合は、それ以外の文字を指定します。

# Examples

```jldoctest
julia> A = [1. 2. ; 3. 4.];

julia> B = [0. 0. ; 0. 0.];

julia> LAPACK.lacpy!(B, A, 'U')
2×2 Matrix{Float64}:
 1.0  2.0
 0.0  4.0
```
