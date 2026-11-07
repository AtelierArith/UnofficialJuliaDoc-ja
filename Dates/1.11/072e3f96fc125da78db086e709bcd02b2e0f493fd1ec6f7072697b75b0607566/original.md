Return the number of ISO weeks in the given year (see https://en.wikipedia.org/wiki/ISO*week*date).

# Examples

```jldoctest
julia> weeksinyear(Year(2022))
52

julia> weeksinyear(Year(2020))
53
```

!!! compat "Julia 1.13"
    This function requires Julia 1.13 or later.

