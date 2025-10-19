```julia
Base.summarysize(obj; exclude=Union{...}, chargeall=Union{...}) -> Int
```

引数から到達可能なすべてのユニークなオブジェクトによって使用されるメモリの量（バイト単位）を計算します。

# キーワード引数

  * `exclude`: トラバーサルから除外するオブジェクトの型を指定します。
  * `chargeall`: 通常は除外されるフィールドであっても、すべてのフィールドのサイズを常に計上するオブジェクトの型を指定します。

他にも [`sizeof`](@ref) を参照してください。

# 例

```jldoctest
julia> Base.summarysize(1.0)
8

julia> Base.summarysize(Ref(rand(100)))
848

julia> sizeof(Ref(rand(100)))
8
```
