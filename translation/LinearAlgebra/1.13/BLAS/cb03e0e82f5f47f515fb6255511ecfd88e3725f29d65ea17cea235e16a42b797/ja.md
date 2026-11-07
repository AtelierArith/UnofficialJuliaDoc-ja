```julia
asum(n, X, incx)
```

ストライドが `incx` の配列 `X` の先頭 `n` 個の要素について、絶対値の合計を求めます。

実数配列の場合、絶対値は各要素の絶対値です。複素数配列の場合、各要素の実部の絶対値と虚部の絶対値の和です。

# Examples

```jldoctest
julia> BLAS.asum(5, fill(1.0im, 10), 2)
5.0

julia> BLAS.asum(2, fill(1.0im, 10), 5)
2.0
```
