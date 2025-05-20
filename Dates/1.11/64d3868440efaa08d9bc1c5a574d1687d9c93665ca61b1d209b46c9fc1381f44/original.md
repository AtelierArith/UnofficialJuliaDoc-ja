```
isleapyear(dt::TimeType) -> Bool
```

Return `true` if the year of `dt` is a leap year.

# Examples

```jldoctest
julia> isleapyear(Date("2004"))
true

julia> isleapyear(Date("2005"))
false
```
