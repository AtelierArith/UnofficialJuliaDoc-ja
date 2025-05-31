```
operator_associativity(s::Symbol)
```

Return a symbol representing the associativity of operator `s`. Left- and right-associative operators return `:left` and `:right`, respectively. Return `:none` if `s` is non-associative or an invalid operator.

# Examples

```jldoctest
julia> Base.operator_associativity(:-), Base.operator_associativity(:+), Base.operator_associativity(:^)
(:left, :none, :right)

julia> Base.operator_associativity(:⊗), Base.operator_associativity(:sin), Base.operator_associativity(:→)
(:left, :none, :right)
```
