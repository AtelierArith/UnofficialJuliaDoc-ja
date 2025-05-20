```
oftype(x, y)
```

Convert `y` to the type of `x` i.e. `convert(typeof(x), y)`.

# Examples

```jldoctest
julia> x = 4;

julia> y = 3.;

julia> oftype(x, y)
3

julia> oftype(y, x)
4.0
```
