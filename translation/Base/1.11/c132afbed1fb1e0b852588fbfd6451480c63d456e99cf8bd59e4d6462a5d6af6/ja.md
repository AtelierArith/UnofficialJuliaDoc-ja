```
count!([f=identity,] r, A)
```

`f` が `true` を返す `A` の要素の数を、`r` の単一次元に対してカウントし、その結果を `r` にインプレースで書き込みます。

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。


!!! compat "Julia 1.5"
    インプレース `count!` は Julia 1.5 で追加されました。


# 例

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> count!(<=(2), [1 1], A)
1×2 Matrix{Int64}:
 1  1

julia> count!(<=(2), [1; 1], A)
2-element Vector{Int64}:
 2
 0
```
