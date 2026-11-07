```julia
lcm(x, y...)
```

最小公倍数（正の値）。ただし、引数のいずれかがゼロの場合はゼロです。引数には整数と有理数を指定できます。

``a`` が ``b`` の倍数であるとは、ある整数 ``m`` が存在し、``a=mb`` が成り立つことをいいます。

!!! compat "Julia 1.4"
    有理数の引数を指定するには、Julia 1.4 以降が必要です。


# Examples

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
