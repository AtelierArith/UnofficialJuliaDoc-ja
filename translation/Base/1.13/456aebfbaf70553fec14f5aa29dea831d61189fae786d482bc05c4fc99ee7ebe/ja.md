```julia
prod!(r, A)
```

`A`の要素を、`r`の単一要素の次元に沿って乗算し、結果を`r`に書き込みます。

!!! warning
    変更対象の引数がほかの引数とメモリを共有している場合、予期しない動作になることがあります。


# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> prod!([1; 1], A)
2-element Vector{Int64}:
  2
 12

julia> prod!([1 1], A)
1×2 Matrix{Int64}:
 3  8
```
