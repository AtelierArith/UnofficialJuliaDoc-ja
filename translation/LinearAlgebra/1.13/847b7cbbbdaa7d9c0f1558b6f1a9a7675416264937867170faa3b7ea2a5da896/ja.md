```julia
copytrito!(B, A, uplo) -> B
```

行列 `A` の三角部分を、別の行列 `B` にコピーします。`uplo` は、行列 `A` のどの部分を `B` にコピーするかを指定します。下三角部分には `uplo = 'L'` を、上三角部分には `uplo = 'U'` を設定します。

!!! compat "Julia 1.11"
    `copytrito!` は Julia 1.11 以降で使用できます。


# Examples

```jldoctest
julia> A = [1 2 ; 3 4];

julia> B = [0 0 ; 0 0];

julia> copytrito!(B, A, 'L')
2×2 Matrix{Int64}:
 1  0
 3  4
```
