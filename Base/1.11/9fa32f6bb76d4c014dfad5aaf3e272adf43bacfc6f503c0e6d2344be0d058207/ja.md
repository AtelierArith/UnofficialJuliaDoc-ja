```
prod!(r, A)
```

`A`の要素を`r`の単一次元にわたって乗算し、結果を`r`に書き込みます。

!!! warning
    いかなる変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになる可能性があります。


# 例

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
