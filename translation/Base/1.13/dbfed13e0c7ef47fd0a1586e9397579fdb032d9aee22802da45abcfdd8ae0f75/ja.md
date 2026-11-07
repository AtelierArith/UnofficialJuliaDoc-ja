```julia
isdispatchtuple(T)
```

型 `T` が、ディスパッチで型シグネチャとして使われる [`Tuple`](@ref) かどうかを判定します。これに該当するには、タプル型の各要素が次のいずれかでなければなりません。

  * [concrete](@ref isconcretetype) だが、[kind type](@ref Base.iskindtype) ではない
  * `U` に自由型変数を含まない [`Type{U}`](@ref Type)

!!! note
    ディスパッチタプルは、要素を持つ部分型が存在しないため、メソッドディスパッチに関係します。

    たとえば、`Tuple{Int, DataType}` は具象型ですが、`Tuple{Int, Type{Bool}}` は要素を持つ部分型なので、ディスパッチタプルではありません。

    `Tuple{Tuple{DataType}}` はディスパッチタプルです。`Tuple{DataType}` は具象型であり、種類ではないためです。部分型 `Tuple{Tuple{Type{Int}}}` は要素を持ちません。


`T` が型でない場合は、`false` を返します。

# Examples

```jldoctest
julia> isdispatchtuple(Int)
false

julia> isdispatchtuple(Tuple{Int})
true

julia> isdispatchtuple(Tuple{Number})
false

julia> isdispatchtuple(Tuple{DataType})
false

julia> isdispatchtuple(Tuple{Type{Int}})
true

julia> isdispatchtuple(Tuple{Type})
false
```
