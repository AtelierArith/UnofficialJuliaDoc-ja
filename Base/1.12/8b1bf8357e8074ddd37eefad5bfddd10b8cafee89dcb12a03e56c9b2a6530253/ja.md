```julia
eltype(type)
```

与えられた `type` のコレクションを反復処理することによって生成される要素の型を決定します。辞書型の場合、これは `Pair{KeyType,ValType}` になります。便利のために、`eltype(x) = eltype(typeof(x))` という定義が提供されているので、インスタンスを型の代わりに渡すことができます。ただし、型引数を受け取る形式は新しい型のために定義する必要があります。

参照: [`keytype`](@ref), [`typeof`](@ref).

# 例

```jldoctest
julia> eltype(fill(1f0, (2,2)))
Float32

julia> eltype(fill(0x1, (2,2)))
UInt8
```
