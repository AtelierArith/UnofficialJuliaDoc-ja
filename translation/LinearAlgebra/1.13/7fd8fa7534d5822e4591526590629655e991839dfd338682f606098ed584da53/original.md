```julia
BandIndex(band, index)
```

Represent a Cartesian index as a linear index along a band. This type is primarily meant to index into a specific band without branches, so, for best performance, `band` should be a compile-time constant.
