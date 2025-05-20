```
^(x, y)
```

Exponentiation operator.

If `x` and `y` are integers, the result may overflow. To enter numbers in scientific notation, use [`Float64`](@ref) literals such as `1.2e3` rather than `1.2 * 10^3`.

If `y` is an `Int` literal (e.g. `2` in `x^2` or `-3` in `x^-3`), the Julia code `x^y` is transformed by the compiler to `Base.literal_pow(^, x, Val(y))`, to enable compile-time specialization on the value of the exponent. (As a default fallback we have `Base.literal_pow(^, x, Val(y)) = ^(x,y)`, where usually `^ == Base.^` unless `^` has been defined in the calling namespace.) If `y` is a negative integer literal, then `Base.literal_pow` transforms the operation to `inv(x)^-y` by default, where `-y` is positive.

See also [`exp2`](@ref), [`<<`](@ref).

# Examples

```jldoctest
julia> 3^5
243

julia> 3^-1  # uses Base.literal_pow
0.3333333333333333

julia> p = -1;

julia> 3^p
ERROR: DomainError with -1:
Cannot raise an integer x to a negative power -1.
[...]

julia> 3.0^p
0.3333333333333333

julia> 10^19 > 0  # integer overflow
false

julia> big(10)^19 == 1e19
true
```
