```
unique(f, itr)
```

`itr`の要素に適用された`f`によって生成された各ユニークな値から1つの値を含む配列を返します。

# 例

```jldoctest
julia> unique(x -> x^2, [1, -1, 3, -3, 4])
3-element Vector{Int64}:
 1
 3
 4
```

この機能は、配列内のユニークな要素の最初の出現の*インデックス*を抽出するためにも使用できます：

```jldoctest
julia> a = [3.1, 4.2, 5.3, 3.1, 3.1, 3.1, 4.2, 1.7];

julia> i = unique(i -> a[i], eachindex(a))
4-element Vector{Int64}:
 1
 2
 3
 8

julia> a[i]
4-element Vector{Float64}:
 3.1
 4.2
 5.3
 1.7

julia> a[i] == unique(a)
true
```
