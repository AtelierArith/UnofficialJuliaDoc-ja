```julia
invpermute!(v, p)
```

[`permute!`](@ref)と同様ですが、与えられた置換の逆が適用されます。

事前に割り当てられた出力配列（例：`u = similar(v)`）がある場合は、代わりに`u[p] = v`を使用する方が速いです。(`invpermute!`は内部でデータのコピーを割り当てます。)

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。


# 例

```jldoctest
julia> A = [1, 1, 3, 4];

julia> perm = [2, 4, 3, 1];

julia> invpermute!(A, perm);

julia> A
4-element Vector{Int64}:
 4
 1
 3
 1
```
