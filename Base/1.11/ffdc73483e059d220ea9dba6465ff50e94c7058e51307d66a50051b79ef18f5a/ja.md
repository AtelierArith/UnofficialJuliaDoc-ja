```
operator_precedence(s::Symbol)
```

演算子 `s` の優先順位を表す整数を返します。他の演算子に対して相対的な優先順位です。番号が高い演算子は、番号が低い演算子よりも優先されます。`s` が有効な演算子でない場合は `0` を返します。

# 例

```jldoctest
julia> Base.operator_precedence(:+), Base.operator_precedence(:*), Base.operator_precedence(:.)
(11, 12, 17)

julia> Base.operator_precedence(:sin), Base.operator_precedence(:+=), Base.operator_precedence(:(=))  # (Note the necessary parens on `:(=)`)
(0, 1, 1)
```
