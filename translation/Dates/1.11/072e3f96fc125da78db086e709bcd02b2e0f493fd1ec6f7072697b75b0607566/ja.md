指定された年の ISO 週の数を返します（https://en.wikipedia.org/wiki/ISO*week*date を参照）。

# Examples

```jldoctest
julia> weeksinyear(Year(2022))
52

julia> weeksinyear(Year(2020))
53
```

!!! compat "Julia 1.13"
    この関数を使用するには、Julia 1.13 以降が必要です。

