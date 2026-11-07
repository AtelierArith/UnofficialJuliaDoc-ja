```julia
operator_precedence(s::Symbol)
```

演算子 `s` の優先順位を表す整数を返します。数値が大きい演算子ほど、優先順位が高くなります。`s` が有効な演算子でない場合は、`0` を返します。

# Examples

```jldoctest
julia> Base.operator_precedence(:+), Base.operator_precedence(:*), Base.operator_precedence(:.)
(11, 12, 17)

julia> Base.operator_precedence(:sin), Base.operator_precedence(:+=), Base.operator_precedence(:(=))  # (Note the necessary parens on `:(=)`)
(0, 1, 1)
```
