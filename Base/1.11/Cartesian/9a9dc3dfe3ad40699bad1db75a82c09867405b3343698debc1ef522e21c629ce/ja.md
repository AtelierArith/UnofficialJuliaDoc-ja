```
@nexprs N expr
```

`N` 個の式を生成します。`expr` は無名関数の式である必要があります。

# 例

```jldoctest
julia> @macroexpand Base.Cartesian.@nexprs 4 i -> y[i] = A[i+j]
quote
    y[1] = A[1 + j]
    y[2] = A[2 + j]
    y[3] = A[3 + j]
    y[4] = A[4 + j]
end
```
