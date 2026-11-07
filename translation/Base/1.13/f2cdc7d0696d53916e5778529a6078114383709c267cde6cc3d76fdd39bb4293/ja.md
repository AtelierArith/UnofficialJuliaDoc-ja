```julia
cumprod(itr)
```

イテレータの累積積。

関連項目: [`cumprod!`](@ref)、[`accumulate`](@ref)、[`cumsum`](@ref)。

!!! compat "Julia 1.5"
    配列以外のイテレータに対する `cumprod` の使用には、Julia 1.5 以降が必要です。


# Examples

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
