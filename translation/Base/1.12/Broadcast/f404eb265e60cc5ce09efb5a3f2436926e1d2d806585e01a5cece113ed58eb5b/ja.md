```julia
Broadcast.broadcastable(x)
```

`x` または `x` のようなオブジェクトを返します。これにより [`axes`](@ref)、インデックス付けをサポートし、その型が [`ndims`](@ref) をサポートします。

`x` が反復をサポートする場合、返される値は [`collect(x)`](@ref) と同じ `axes` とインデックス付けの動作を持つべきです。

`x` が `AbstractArray` ではないが、`axes`、インデックス付けをサポートし、その型が `ndims` をサポートする場合、`broadcastable(::typeof(x))` は単に自分自身を返すように実装されるかもしれません。さらに、`x` が独自の [`BroadcastStyle`](@ref) を定義している場合、カスタムスタイルに効果を持たせるためには `broadcastable` メソッドを自分自身を返すように定義しなければなりません。

# 例

```jldoctest
julia> Broadcast.broadcastable([1,2,3]) # 配列はすでに axes とインデックス付けをサポートしているため、`identity` のよう
3-element Vector{Int64}:
 1
 2
 3

julia> Broadcast.broadcastable(Int) # 型は axes、インデックス付け、または反復をサポートしないが、スカラーとして一般的に使用される
Base.RefValue{Type{Int64}}(Int64)

julia> Broadcast.broadcastable("hello") # 文字列は反復の一致の慣例を破り、代わりにスカラーのように振る舞う
Base.RefValue{String}("hello")
```
