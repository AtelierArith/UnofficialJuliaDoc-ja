```julia
unique(f, itr)
```

`itr` の各要素に `f` を適用して得られる一意な値ごとに、`itr` の値を1つずつ含む配列を返します。

# Examples

```jldoctest
julia> unique(x -> x^2, [1, -1, 3, -3, 4])
3-element Vector{Int64}:
 1
 3
 4
```

この機能を使って、配列内で一意な要素が最初に現れる位置の *インデックス* を取り出すこともできます。

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
