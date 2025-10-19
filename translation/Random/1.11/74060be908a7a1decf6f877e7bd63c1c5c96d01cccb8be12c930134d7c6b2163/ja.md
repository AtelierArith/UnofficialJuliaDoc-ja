```julia
randcycle!([rng=default_rng(),] A::Array{<:Integer})
```

`A`に長さ`n = length(A)`のランダムな循環置換を構築します。オプションの`rng`引数は乱数生成器を指定します。詳細は[Random Numbers](@ref)を参照してください。

ここで「循環置換」とは、すべての要素が単一のサイクル内にあることを意味します。`A`が空でない場合（`n > 0`）、可能な循環置換は$(n-1)!$通りあり、これらは均等にサンプリングされます。`A`が空の場合、`randcycle!`は変更を加えません。

[`randcycle`](@ref)は、新しいベクトルを割り当てるこの関数のバリアントです。

# 例

```jldoctest
julia> randcycle!(Xoshiro(123), Vector{Int}(undef, 6))
6-element Vector{Int64}:
 5
 4
 2
 6
 3
 1
```
