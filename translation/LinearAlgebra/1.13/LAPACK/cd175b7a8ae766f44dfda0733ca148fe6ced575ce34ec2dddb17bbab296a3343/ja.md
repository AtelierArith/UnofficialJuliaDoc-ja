```julia
lacpy!(B, A, uplo) -> B
```

行列 `A` の全部または一部を、別の行列 `B` にコピーします。uplo は、行列 `A` のどの部分を `B` にコピーするかを指定します。下三角部分には `uplo = 'L'`、上三角部分には `uplo = 'U'` を指定し、それ以外の文字を指定すると行列 `A` 全体が対象になります。

# Examples

```jldoctest
julia> A = [1. 2. ; 3. 4.];

julia> B = [0. 0. ; 0. 0.];

julia> LAPACK.lacpy!(B, A, 'U')
2×2 Matrix{Float64}:
 1.0  2.0
 0.0  4.0
```
