```julia
partialsortperm(v, k; by=identity, lt=isless, rev=false)
```

ベクトル `v` の部分的な順列 `I` を返します。これにより、`v[I]` はインデックス `k` での `v` の完全にソートされたバージョンの値を返します。`k` が範囲の場合、インデックスのベクトルが返されます。`k` が整数の場合、単一のインデックスが返されます。順序は `sort!` と同じキーワードを使用して指定されます。順列は安定しており、同じ要素のインデックスは昇順で表示されます。

この関数は、`sortperm(...)[k]` を呼び出すよりも効率的ですが、同等です。

# 例

```jldoctest
julia> v = [3, 1, 2, 1];

julia> v[partialsortperm(v, 1)]
1

julia> p = partialsortperm(v, 1:3)
3-element view(::Vector{Int64}, 1:3) with eltype Int64:
 2
 4
 3

julia> v[p]
3-element Vector{Int64}:
 1
 1
 2
```
