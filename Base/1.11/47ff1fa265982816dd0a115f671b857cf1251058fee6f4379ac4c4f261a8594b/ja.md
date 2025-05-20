```
digits!(array, n::Integer; base::Integer = 10)
```

指定された基数で `n` の桁を配列に埋めます。より重要な桁は高いインデックスにあります。配列の長さが不十分な場合、最も重要でない桁が配列の長さまで埋められます。配列の長さが過剰な場合、余分な部分はゼロで埋められます。

# 例

```jldoctest
julia> digits!([2, 2, 2, 2], 10, base = 2)
4-element Vector{Int64}:
 0
 1
 0
 1

julia> digits!([2, 2, 2, 2, 2, 2], 10, base = 2)
6-element Vector{Int64}:
 0
 1
 0
 1
 0
 0
```
