```
hvcat(blocks_per_row::Union{Tuple{Vararg{Int}}, Int}, values...)
```

1回の呼び出しでの水平および垂直の連結。この関数はブロック行列構文のために呼び出されます。最初の引数は、各ブロック行に連結する引数の数を指定します。最初の引数が単一の整数 `n` の場合、すべてのブロック行は `n` のブロック列を持つと仮定されます。

# 例

```jldoctest
julia> a, b, c, d, e, f = 1, 2, 3, 4, 5, 6
(1, 2, 3, 4, 5, 6)

julia> [a b c; d e f]
2×3 Matrix{Int64}:
 1  2  3
 4  5  6

julia> hvcat((3,3), a,b,c,d,e,f)
2×3 Matrix{Int64}:
 1  2  3
 4  5  6

julia> [a b; c d; e f]
3×2 Matrix{Int64}:
 1  2
 3  4
 5  6

julia> hvcat((2,2,2), a,b,c,d,e,f)
3×2 Matrix{Int64}:
 1  2
 3  4
 5  6
julia> hvcat((2,2,2), a,b,c,d,e,f) == hvcat(2, a,b,c,d,e,f)
true
```
