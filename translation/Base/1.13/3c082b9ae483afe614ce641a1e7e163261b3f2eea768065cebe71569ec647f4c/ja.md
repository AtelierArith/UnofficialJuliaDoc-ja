```julia
digits!(array, n::Integer; base::Integer = 10)
```

指定された基数で、`n`の各桁を配列に格納します。上位の桁ほど大きなインデックスに格納されます。配列の長さが足りない場合は、最下位の桁から配列の長さ分だけ格納します。配列の長さが余る場合は、余った部分をゼロで埋めます。

# Examples

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
