```julia
eltype(type)
```

指定された`type`のコレクションを反復処理したときに生成される要素の型を判定します。辞書型の場合、これは`Pair{KeyType,ValType}`になります。インスタンスを型の代わりに渡せるよう、便宜上`eltype(x) = eltype(typeof(x))`の定義も用意されています。ただし、新しい型では型引数を受け取る形式を定義してください。

関連項目: [`keytype`](@ref)、[`typeof`](@ref)。

# Examples

```jldoctest
julia> eltype(fill(1f0, (2,2)))
Float32

julia> eltype(fill(0x1, (2,2)))
UInt8
```
