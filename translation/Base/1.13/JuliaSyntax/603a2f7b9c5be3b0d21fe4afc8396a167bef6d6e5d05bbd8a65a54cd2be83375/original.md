```julia
filename(x)
```

Get file name associated with `source`, or an empty string if one didn't exist.

For objects `x` such as syntax trees, defers to `filename(sourcefile(x))` by default.
