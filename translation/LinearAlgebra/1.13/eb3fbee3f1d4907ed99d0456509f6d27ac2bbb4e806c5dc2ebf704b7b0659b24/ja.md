```julia
tr(M)
```

行列のトレース。`M`の対角要素の和を求めます。

# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> tr(A)
5
```
