```julia
operator_associativity(s::Symbol)
```

演算子 `s` の結合性を表す記号を返します。左結合演算子の場合は `:left`、右結合演算子の場合は `:right` を返します。`s` が非結合演算子または無効な演算子の場合は、`:none` を返します。

# Examples

```jldoctest
julia> Base.operator_associativity(:-), Base.operator_associativity(:+), Base.operator_associativity(:^)
(:left, :none, :right)

julia> Base.operator_associativity(:⊗), Base.operator_associativity(:sin), Base.operator_associativity(:→)
(:left, :none, :right)
```
