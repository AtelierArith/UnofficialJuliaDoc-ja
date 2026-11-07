```julia
hvcat(blocks_per_row::Union{Tuple{Vararg{Int}}, Int}, values...)
```

1回の呼び出しで、水平および垂直方向に連結します。この関数はブロック行列構文で呼び出されます。最初の引数には、各ブロック行で連結する引数の数を指定します。最初の引数が単一の整数 `n` の場合、すべてのブロック行のブロック列数は `n` であるとみなされます。

# Examples

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
