```julia
oftype(x, y)
```

`y`を`x`の型に変換します。つまり、`convert(typeof(x), y)`です。

# Examples

```jldoctest
julia> x = 4;

julia> y = 3.;

julia> oftype(x, y)
3

julia> oftype(y, x)
4.0
```
