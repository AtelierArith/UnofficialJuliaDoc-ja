```
elsize(type)
```

与えられた `type` 内に格納されている [`eltype`](@ref) の連続する要素間のメモリストライドをバイト単位で計算します。配列の要素は均一な線形ストライドで密に格納されていると仮定します。

# 例

```jldoctest
julia> Base.elsize(rand(Float32, 10))
4
```
