```
lcm(x, y...)
```

最小公倍数（正の）または引数のいずれかがゼロの場合はゼロ。引数は整数および有理数である可能性があります。

!!! compat "Julia 1.4"
    有理数の引数はJulia 1.4以降が必要です。


# 例

```jldoctest
julia> lcm(2, 3)
6

julia> lcm(-2, 3)
6

julia> lcm(0, 3)
0

julia> lcm(0, 0)
0

julia> lcm(1//3, 2//3)
2//3

julia> lcm(1//3, -2//3)
2//3

julia> lcm(1//3, 2)
2//1

julia> lcm(1, 3, 5, 7)
105
```
