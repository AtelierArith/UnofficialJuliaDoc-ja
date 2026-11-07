```julia
extrema!(r, A)
```

`r` の単一要素の次元に沿って `A` の最小値と最大値を計算し、結果を `r` に書き込みます。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作になることがあります。


!!! compat "Julia 1.8"
    このメソッドを使用するには、Julia 1.8 以降が必要です。


# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> extrema!([(1, 1); (1, 1)], A)
2-element Vector{Tuple{Int64, Int64}}:
 (1, 2)
 (3, 4)

julia> extrema!([(1, 1);; (1, 1)], A)
1×2 Matrix{Tuple{Int64, Int64}}:
 (1, 3)  (2, 4)
```
