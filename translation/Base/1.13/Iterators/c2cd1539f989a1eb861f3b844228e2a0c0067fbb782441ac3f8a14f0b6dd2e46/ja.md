```julia
findeach(f, it)
findeach(it)
```

`pairs(it)` のキーと値のペアから、`f(value)` が `true` を返すようなすべてのキーを生成するイテレーターです。

`f` が指定されていない場合、デフォルトは `identity` です。

`Iterators.findeach` は、`findall` に相当する遅延評価版です。

!!! compat "Julia 1.13"
    `findeach` を使用するには、Julia 1.13 以降が必要です。


# Examples

```jldoctest
julia> collect(Iterators.findeach(isodd, Dict(2 => 3, 3 => 2)))
1-element Vector{Int64}:
 2

julia> only(Iterators.findeach(==(1), [3,6,2,1]))
4
```
