```
operator_precedence(s::Symbol)
```

Return an integer representing the precedence of operator `s`, relative to other operators. Higher-numbered operators take precedence over lower-numbered operators. Return `0` if `s` is not a valid operator.

# Examples

```jldoctest
julia> Base.operator_precedence(:+), Base.operator_precedence(:*), Base.operator_precedence(:.)
(11, 12, 17)

julia> Base.operator_precedence(:sin), Base.operator_precedence(:+=), Base.operator_precedence(:(=))  # (Note the necessary parens on `:(=)`)
(0, 1, 1)
```
