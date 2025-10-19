```julia
DatePeriod
Year
Quarter
Month
Week
Day
```

Intervals of time greater than or equal to a day. Conventional comparisons between `DatePeriod`s are not all valid. (eg `Week(1) == Day(7)`, but `Year(1) != Day(365)`)
