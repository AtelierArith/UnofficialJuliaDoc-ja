```julia
partialsortperm!(ix, v, k; by=identity, lt=isless, rev=false)
```

[`partialsortperm`](@ref)と同様ですが、`v`と同じサイズの、事前に確保されたインデックスベクトル`ix`を受け取ります。このベクトルには、`v`のインデックス（の順列）が格納されます。

`ix`には、`v`のインデックスが初期値として格納されます。

（通常、`v`のインデックスは`1:length(v)`ですが、`v`が`OffsetArray`などの1始まりでないインデックスを持つ代替配列型の場合、`ix`も同じインデックスを持つ必要があります。）

呼び出しから戻ると、`ix`では、`k`のインデックスがソート後の位置にあることが保証されます。したがって、

```julia
partialsortperm!(ix, v, k);
v[ix[k]] == partialsort(v, k)
```

戻り値は、`k`が整数の場合は`ix`の`k`番目の要素、`k`が範囲の場合は`ix`のビューです。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作になることがあります。


# Examples

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

```julia

```
