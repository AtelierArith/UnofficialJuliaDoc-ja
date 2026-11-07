`alignment(io, X)` returns a tuple (left,right) showing how many characters are needed on either side of an alignment feature such as a decimal point.

# Examples

```jldoctest
julia> Base.alignment(stdout, 42)
(2, 0)

julia> Base.alignment(stdout, 4.23)
(1, 3)

julia> Base.alignment(stdout, 1 + 10im)
(3, 5)
```
