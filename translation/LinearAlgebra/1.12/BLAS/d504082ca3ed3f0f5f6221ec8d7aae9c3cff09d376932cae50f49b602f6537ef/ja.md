```julia
dot(n, X, incx, Y, incy)
```

`incx`のストライドを持つ配列`X`の`n`要素と、`incy`のストライドを持つ配列`Y`の`n`要素からなる2つのベクトルのドット積。

# 例

```jldoctest
julia> BLAS.dot(10, fill(1.0, 10), 1, fill(1.0, 20), 2)
10.0
```
