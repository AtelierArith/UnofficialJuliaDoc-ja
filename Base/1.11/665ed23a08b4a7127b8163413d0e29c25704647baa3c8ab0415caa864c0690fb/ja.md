```
merge!(d::AbstractDict, others::AbstractDict...)
```

他のコレクションからのペアでコレクションを更新します。詳細は[`merge`](@ref)を参照してください。

# 例

```jldoctest
julia> d1 = Dict(1 => 2, 3 => 4);

julia> d2 = Dict(1 => 4, 4 => 5);

julia> merge!(d1, d2);

julia> d1
Dict{Int64, Int64} with 3 entries:
  4 => 5
  3 => 4
  1 => 4
```
