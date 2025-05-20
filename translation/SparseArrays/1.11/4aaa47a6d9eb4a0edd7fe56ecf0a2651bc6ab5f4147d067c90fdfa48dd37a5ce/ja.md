```
dropstored!(x::SparseVector, i::Integer)
```

エントリ `x[i]` が保存されている場合は `x` から削除し、そうでない場合は何もしません。

# 例

```jldoctest
julia> x = sparsevec([1, 3], [1.0, 2.0])
3-element SparseVector{Float64, Int64} with 2 stored entries:
  [1]  =  1.0
  [3]  =  2.0

julia> SparseArrays.dropstored!(x, 3)
3-element SparseVector{Float64, Int64} with 1 stored entry:
  [1]  =  1.0

julia> SparseArrays.dropstored!(x, 2)
3-element SparseVector{Float64, Int64} with 1 stored entry:
  [1]  =  1.0
```
