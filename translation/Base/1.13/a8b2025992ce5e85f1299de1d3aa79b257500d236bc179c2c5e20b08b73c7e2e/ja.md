```julia
keepat!(a::Vector, inds)
keepat!(a::BitVector, inds)
```

`inds`で指定されていないすべてのインデックスの要素を削除し、変更後の`a`を返します。残された要素は、空いた位置を埋めるように詰められます。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作になることがあります。


`inds`は、昇順で重複のない整数インデックスのイテレーターでなければなりません。[`deleteat!`](@ref)も参照してください。

!!! compat "Julia 1.7"
    この関数はJulia 1.7以降で利用できます。


# Examples

```jldoctest
julia> keepat!([6, 5, 4, 3, 2, 1], 1:2:5)
3-element Vector{Int64}:
 6
 4
 2
```
