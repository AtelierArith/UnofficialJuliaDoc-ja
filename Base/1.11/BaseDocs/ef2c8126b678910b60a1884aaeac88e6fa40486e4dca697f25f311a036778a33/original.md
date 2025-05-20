```
Matrix{T}(missing, m, n)
```

Construct a [`Matrix{T}`](@ref) of size `m`×`n`, initialized with [`missing`](@ref) entries. Element type `T` must be able to hold these values, i.e. `Missing <: T`.

# Examples

```jldoctest
julia> Matrix{Union{Missing, String}}(missing, 2, 3)
2×3 Matrix{Union{Missing, String}}:
 missing  missing  missing
 missing  missing  missing
```
