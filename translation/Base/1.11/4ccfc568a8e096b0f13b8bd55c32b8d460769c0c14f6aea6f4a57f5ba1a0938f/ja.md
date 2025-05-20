```
cumprod(itr)
```

イテレータの累積積。

関連項目としては [`cumprod!`](@ref)、[`accumulate`](@ref)、[`cumsum`](@ref) があります。

!!! compat "Julia 1.5"
    非配列イテレータに対する `cumprod` は、少なくとも Julia 1.5 が必要です。


# 例

```jldoctest
julia> cumprod(fill(1//2, 3))
3-element Vector{Rational{Int64}}:
 1//2
 1//4
 1//8

julia> cumprod((1, 2, 1, 3, 1))
(1, 2, 2, 6, 6)

julia> cumprod("julia")
5-element Vector{String}:
 "j"
 "ju"
 "jul"
 "juli"
 "julia"
```
