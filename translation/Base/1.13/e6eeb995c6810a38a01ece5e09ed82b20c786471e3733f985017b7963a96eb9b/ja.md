```julia
ispositive(x)
```

`x > 0`かどうかをテストします。[`isnegative`](@ref)も参照してください。

!!! compat "Julia 1.13"
    この関数を使用するには、Julia 1.13以降が必要です。


# Examples

```jldoctest
julia> ispositive(-4.0)
false

julia> ispositive(99)
true

julia> ispositive(0.0)
false
```
