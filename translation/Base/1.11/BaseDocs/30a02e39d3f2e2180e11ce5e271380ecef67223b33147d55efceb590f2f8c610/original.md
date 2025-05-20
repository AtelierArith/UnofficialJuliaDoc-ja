```
a ? b : c
```

Short form for conditionals; read "if `a`, evaluate `b` otherwise evaluate `c`". Also known as the [ternary operator](https://en.wikipedia.org/wiki/%3F:).

This syntax is equivalent to `if a; b else c end`, but is often used to emphasize the value `b`-or-`c` which is being used as part of a larger expression, rather than the side effects that evaluating `b` or `c` may have.

See the manual section on [control flow](@ref man-conditional-evaluation) for more details.

# Examples

```jldoctest
julia> x = 1; y = 2;

julia> x > y ? println("x is larger") : println("x is not larger")
x is not larger

julia> x > y ? "x is larger" : x == y ? "x and y are equal" : "y is larger"
"y is larger"
```
