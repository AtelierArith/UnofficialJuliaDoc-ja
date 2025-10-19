```julia
gcd(x, y...)
```

最大公約数（正の）またはすべての引数がゼロの場合はゼロ。引数は整数および有理数であることができます。

$$
a
$$

は $b$ の約数であるためには、整数 $m$ が存在して $ma=b$ である必要があります。

!!! compat "Julia 1.4"
    有理数の引数はJulia 1.4以降が必要です。


# 例

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
