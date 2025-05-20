```
widen(x)
```

If `x` is a type, return a "larger" type, defined so that arithmetic operations `+` and `-` are guaranteed not to overflow nor lose precision for any combination of values that type `x` can hold.

For fixed-size integer types less than 128 bits, `widen` will return a type with twice the number of bits.

If `x` is a value, it is converted to `widen(typeof(x))`.

# Examples

```jldoctest
julia> widen(Int32)
Int64

julia> widen(1.5f0)
1.5
```
