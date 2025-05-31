```
operator_associativity(s::Symbol)
```

演算子 `s` の結合性を表すシンボルを返します。左結合および右結合の演算子はそれぞれ `:left` と `:right` を返します。`s` が非結合または無効な演算子の場合は `:none` を返します。

# 例

```jldoctest
julia> Base.operator_associativity(:-), Base.operator_associativity(:+), Base.operator_associativity(:^)
(:left, :none, :right)

julia> Base.operator_associativity(:⊗), Base.operator_associativity(:sin), Base.operator_associativity(:→)
(:left, :none, :right)
```
