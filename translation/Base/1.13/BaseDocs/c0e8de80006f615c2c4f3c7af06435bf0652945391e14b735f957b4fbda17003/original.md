```julia
*(x, y...)
```

Multiplication operator.

Infix `x*y*z*...` calls this function with all arguments, i.e. `*(x, y, z, ...)`, which by default then calls `(x*y) * z * ...` starting from the left.

Juxtaposition such as `2pi` also calls `*(2, pi)`. Note that this operation has higher precedence than a literal `*`. Note also that juxtaposition "0x..." (integer zero times a variable whose name starts with `x`) is forbidden as it clashes with unsigned integer literals: `0x01 isa UInt8`.

Note that overflow is possible for most integer types, including the default `Int`, when multiplying large numbers.

# Examples

```jldoctest
julia> 2 * 7 * 8
112

julia> *(2, 7, 8)
112

julia> [2 0; 0 3] * [1, 10]  # matrix * vector
2-element Vector{Int64}:
  2
 30

julia> 1/2pi, 1/2*pi  # juxtaposition has higher precedence
(0.15915494309189535, 1.5707963267948966)

julia> x = [1, 2]; x'x  # adjoint vector * vector
5
```
