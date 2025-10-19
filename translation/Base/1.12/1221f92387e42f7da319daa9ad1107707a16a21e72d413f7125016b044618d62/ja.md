```julia
sum!(r, A)
```

`A`の要素を`r`の単一次元にわたって合計し、結果を`r`に書き込みます。

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。


# 例

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
