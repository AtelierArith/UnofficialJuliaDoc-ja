```julia
isnegative(x)
```

`x < 0`かどうかをテストします。[`ispositive`](@ref)も参照してください。

!!! compat "Julia 1.13"
    この関数を使用するには、Julia 1.13 以降が必要です。


# Examples

```jldoctest
julia> isnegative(-4.0)
true

julia> isnegative(99)
false

julia> isnegative(-0.0)
false
```
