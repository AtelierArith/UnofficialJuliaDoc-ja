```julia
dot(n, X, incx, Y, incy)
```

ストライドがそれぞれ`incx`および`incy`である配列`X`および`Y`の、`n`個および`n`個の要素からなる2つのベクトルの内積。

# Examples

```jldoctest
julia> BLAS.dot(10, fill(1.0, 10), 1, fill(1.0, 20), 2)
10.0
```
