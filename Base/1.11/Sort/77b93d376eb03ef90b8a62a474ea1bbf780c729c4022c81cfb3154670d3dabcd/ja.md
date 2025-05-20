```
partialsortperm!(ix, v, k; by=identity, lt=isless, rev=false)
```

[`partialsortperm`](@ref) と同様ですが、`v` と同じサイズの事前に割り当てられたインデックスベクトル `ix` を受け入れ、`v` のインデックスの (順列の) 保存に使用されます。

`ix` は `v` のインデックスを含むように初期化されます。

(通常、`v` のインデックスは `1:length(v)` ですが、`v` が `OffsetArray` のような非1ベースのインデックスを持つ代替配列型である場合、`ix` はそれらの同じインデックスを共有しなければなりません)

戻り値として、`ix` は `k` のインデックスがソートされた位置にあることが保証されており、次のようになります。

```julia
partialsortperm!(ix, v, k);
v[ix[k]] == partialsort(v, k)
```

戻り値は、`k` が整数の場合は `ix` の `k` 番目の要素、`k` が範囲の場合は `ix` へのビューです。

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。


# 例

```jldoctest
julia> v = [3, 1, 2, 1];

julia> ix = Vector{Int}(undef, 4);

julia> partialsortperm!(ix, v, 1)
2

julia> ix = [1:4;];

julia> partialsortperm!(ix, v, 2:3)
2-element view(::Vector{Int64}, 2:3) with eltype Int64:
 4
 3
```

```
