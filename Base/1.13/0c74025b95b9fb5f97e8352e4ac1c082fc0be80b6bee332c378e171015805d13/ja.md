```julia
sum!(r, A)
```

`A`の要素を`r`の単一要素の次元に沿って合計し、その結果を`r`に書き込みます。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作が起こることがあります。


# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> sum!([1; 1], A)
2-element Vector{Int64}:
 3
 7

julia> sum!([1 1], A)
1×2 Matrix{Int64}:
 4  6
```
