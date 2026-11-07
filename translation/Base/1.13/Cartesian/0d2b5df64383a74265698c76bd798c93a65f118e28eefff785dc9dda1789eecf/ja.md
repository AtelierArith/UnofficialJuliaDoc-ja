```julia
@nref N A indexexpr
```

`A[i_1, i_2, ...]`のような式を生成します。`indexexpr`には、反復記号の接頭辞または無名関数式を指定できます。

# Examples

```jldoctest
julia> @macroexpand Base.Cartesian.@nref 3 A i
:(A[i_1, i_2, i_3])
```
