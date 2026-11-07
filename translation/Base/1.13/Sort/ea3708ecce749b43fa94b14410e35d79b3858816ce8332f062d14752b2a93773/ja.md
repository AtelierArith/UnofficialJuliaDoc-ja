```julia
partialsortperm(v, k; by=identity, lt=isless, rev=false)
```

ベクトル `v` の部分順列 `I` を返します。これにより、`v[I]` は、完全にソートした `v` の `k` 番目の値を返します。`k` が範囲の場合はインデックスのベクトルを返し、`k` が整数の場合は単一のインデックスを返します。順序は `sort!` と同じキーワードで指定します。順列は安定しており、等しい要素のインデックスは昇順で並びます。

この関数は `sortperm(...)[k]` を呼び出すのと同等ですが、より効率的です。

# Examples

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
