```julia
canonicalize(::CompoundPeriod) -> CompoundPeriod
```

Reduces the `CompoundPeriod` into its canonical form by applying the following rules:

  * Any `Period` large enough be partially representable by a coarser `Period` will be broken into multiple `Period`s (eg. `Hour(30)` becomes `Day(1) + Hour(6)`)
  * `Period`s with opposite signs will be combined when possible (eg. `Hour(1) - Day(1)` becomes `-Hour(23)`)

# Examples

```jldoctest
julia> canonicalize(Dates.CompoundPeriod(Dates.Hour(12), Dates.Hour(13)))
1 day, 1 hour

julia> canonicalize(Dates.CompoundPeriod(Dates.Hour(-1), Dates.Minute(1)))
-59 minutes

julia> canonicalize(Dates.CompoundPeriod(Dates.Month(1), Dates.Week(-2)))
1 month, -2 weeks

julia> canonicalize(Dates.CompoundPeriod(Dates.Minute(50000)))
4 weeks, 6 days, 17 hours, 20 minutes
```
