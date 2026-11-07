```julia
setindex(t::Tuple, v, i::Integer)
```

`t`に似た新しいタプルを作成し、インデックス`i`の値を`v`に設定します。範囲外の場合は`BoundsError`をスローします。

# Examples

```jldoctest
julia> Base.setindex((1, 2, 6), 2, 3) == (1, 2, 2)
true
```
