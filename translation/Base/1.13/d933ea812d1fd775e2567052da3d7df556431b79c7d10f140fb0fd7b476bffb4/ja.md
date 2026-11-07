```julia
filter(f, itr::SkipMissing{<:AbstractArray})
```

指定された`SkipMissing`イテレータでラップされた配列に似たベクトルを返します。ただし、欠損値と、`f`が`false`を返す要素はすべて除外されます。

!!! compat "Julia 1.2"
    このメソッドを使用するには、Julia 1.2以降が必要です。


# Examples

```jldoctest
julia> x = [1 2; missing 4]
2×2 Matrix{Union{Missing, Int64}}:
 1         2
  missing  4

julia> filter(isodd, skipmissing(x))
1-element Vector{Int64}:
 1
```
