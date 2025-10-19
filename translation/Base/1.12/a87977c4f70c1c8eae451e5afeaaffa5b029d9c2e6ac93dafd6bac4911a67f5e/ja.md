```julia
filter(f, itr::SkipMissing{<:AbstractArray})
```

与えられた `SkipMissing` イテレータでラップされた配列に似たベクトルを返しますが、すべての欠損要素と `f` が `false` を返す要素は削除されます。

!!! compat "Julia 1.2"
    このメソッドは Julia 1.2 以降が必要です。


# 例

```jldoctest
julia> x = [1 2; missing 4]
2×2 Matrix{Union{Missing, Int64}}:
 1         2
  missing  4

julia> filter(isodd, skipmissing(x))
1-element Vector{Int64}:
 1
```
