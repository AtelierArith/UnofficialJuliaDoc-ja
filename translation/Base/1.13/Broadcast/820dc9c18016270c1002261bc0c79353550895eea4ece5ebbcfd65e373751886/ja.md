```julia
Broadcast.broadcastable(x)
```

`x`、または`x`のようなオブジェクトを返してください。そのオブジェクトは[`axes`](@ref)とインデックス指定をサポートし、型が[`ndims`](@ref)をサポートする必要があります。

`x`が反復処理をサポートする場合、返される値は[`collect(x)`](@ref)と同じ`axes`およびインデックス指定の動作を備えている必要があります。

`x`が`AbstractArray`ではないものの、`axes`とインデックス指定をサポートし、その型が`ndims`をサポートする場合、`broadcastable(::typeof(x))`は自身を返すだけの実装にできます。さらに、`x`が独自の[`BroadcastStyle`](@ref)を定義する場合、カスタムスタイルを有効にするには、`broadcastable`メソッドが自身を返すように定義する必要があります。

# Examples

```jldoctest
julia> Broadcast.broadcastable([1,2,3]) # like `identity` since arrays already support axes and indexing
3-element Vector{Int64}:
 1
 2
 3

julia> Broadcast.broadcastable(Int) # Types don't support axes, indexing, or iteration but are commonly used as scalars
Base.RefValue{Type{Int64}}(Int64)

julia> Broadcast.broadcastable("hello") # Strings break convention of matching iteration and act like a scalar instead
Base.RefValue{String}("hello")
```
