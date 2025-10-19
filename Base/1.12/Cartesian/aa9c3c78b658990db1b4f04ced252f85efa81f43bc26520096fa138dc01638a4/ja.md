```julia
@nref N A indexexpr
```

`A[i_1, i_2, ...]` のような式を生成します。`indexexpr` は、イテレーションシンボルのプレフィックスまたは無名関数の式のいずれかです。

# 例

```jldoctest
julia> @macroexpand Base.Cartesian.@nref 3 A i
:(A[i_1, i_2, i_3])
```
