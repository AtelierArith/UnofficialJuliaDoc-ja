```julia
DivideError()
```

分母の値が 0 の状態で整数除算が試みられました。

# Examples

```jldoctest
julia> 2/0
Inf

julia> div(2, 0)
ERROR: DivideError: integer division error
Stacktrace:
[...]
```
