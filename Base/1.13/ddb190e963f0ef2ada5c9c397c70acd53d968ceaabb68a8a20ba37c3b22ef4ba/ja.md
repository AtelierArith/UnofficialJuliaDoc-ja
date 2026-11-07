```julia
all!(r, A)
```

`r`の単一要素の次元に沿って、`A`のすべての値が`true`かどうかを判定し、その結果を`r`に書き込みます。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作が起こることがあります。


# Examples

```jldoctest
julia> A = [true false; true false]
2×2 Matrix{Bool}:
 1  0
 1  0

julia> all!(Bool[1; 1], A)
2-element Vector{Bool}:
 0
 0

julia> all!(Bool[1 1], A)
1×2 Matrix{Bool}:
 1  0
```
