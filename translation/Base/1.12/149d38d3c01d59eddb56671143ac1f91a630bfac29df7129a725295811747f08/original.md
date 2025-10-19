```julia
lcm(x, y...)
```

Least common (positive) multiple (or zero if any argument is zero). The arguments may be integer and rational numbers.

$a$ is a multiple of $b$ if there exists an integer $m$ such that $a=mb$.

!!! compat "Julia 1.4"
    Rational arguments require Julia 1.4 or later.


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
