```julia
keepat!(a::Vector, inds)
keepat!(a::BitVector, inds)
```

`inds` で指定されていないすべてのインデックスのアイテムを削除し、修正された `a` を返します。保持されるアイテムは、結果の隙間を埋めるためにシフトされます。

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。


`inds` は、ソートされていてユニークな整数インデックスのイテレータでなければなりません。詳細は [`deleteat!`](@ref) を参照してください。

!!! compat "Julia 1.7"
    この関数は Julia 1.7 以降で利用可能です。


# 例

```jldoctest
julia> keepat!([6, 5, 4, 3, 2, 1], 1:2:5)
3-element Vector{Int64}:
 6
 4
 2
```
