```julia
count!([f=identity,] r, A)
```

`A`の要素のうち、`r`の単一要素の次元に沿って`f`が`true`を返す要素の数を数え、その結果を`r`にインプレースで書き込みます。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作になることがあります。


!!! compat "Julia 1.5"
    inplace `count!`はJulia 1.5で追加されました。


# Examples

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
