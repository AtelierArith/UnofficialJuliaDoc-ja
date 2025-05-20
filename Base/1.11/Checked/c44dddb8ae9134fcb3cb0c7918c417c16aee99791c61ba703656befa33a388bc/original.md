```
Base.checked_length(r)
```

Calculates `length(r)`, but may check for overflow errors where applicable when the result doesn't fit into `Union{Integer(eltype(r)),Int}`.
