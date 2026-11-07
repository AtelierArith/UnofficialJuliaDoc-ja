```julia
invpermute!(v, p)
```

[`permute!`](@ref)と同様ですが、指定された置換の逆置換を適用します。

あらかじめ出力配列を確保してある場合（例：`u = similar(v)`）は、代わりに`u[p] = v`を使うほうが高速です。（`invpermute!`は内部でデータのコピーを確保します。）

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作になることがあります。


# Examples

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
