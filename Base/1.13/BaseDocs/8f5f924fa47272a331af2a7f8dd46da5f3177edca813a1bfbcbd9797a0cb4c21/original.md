```julia
DivideError()
```

Integer division was attempted with a denominator value of 0.

# Examples

```jldoctest
julia> 2/0
Inf

julia> div(2, 0)
ERROR: DivideError: integer division error
Stacktrace:
[...]
```
