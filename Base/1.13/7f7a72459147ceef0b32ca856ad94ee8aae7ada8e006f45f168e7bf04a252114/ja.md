```julia
minimum!(r, A)
```

`r` の単一要素の次元に沿って `A` の最小値を計算し、結果を `r` に書き込みます。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作になることがあります。


# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> minimum!([1; 1], A)
2-element Vector{Int64}:
 1
 3

julia> minimum!([1 1], A)
1×2 Matrix{Int64}:
 1  2
```
