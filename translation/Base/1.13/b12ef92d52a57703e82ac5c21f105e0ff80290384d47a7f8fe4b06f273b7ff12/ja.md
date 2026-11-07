```julia
gcd(x, y...)
```

最大公約数（正の値。すべての引数がゼロの場合はゼロ）。引数には整数と有理数を指定できます。

``a`` が ``b`` の約数であるとは、``m`` が整数であり、``ma=b`` が成り立つことをいいます。

!!! compat "Julia 1.4"
    有理数の引数を指定するには、Julia 1.4 以降が必要です。


# Examples

```jldoctest
julia> gcd(6, 9)
3

julia> gcd(6, -9)
3

julia> gcd(6, 0)
6

julia> gcd(0, 0)
0

julia> gcd(1//3, 2//3)
1//3

julia> gcd(1//3, -2//3)
1//3

julia> gcd(1//3, 2)
1//3

julia> gcd(0, 0, 10, 15)
5
```
