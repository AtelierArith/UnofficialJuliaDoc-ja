```julia
unsigned(T::Integer)
```

整数ビット型を同じサイズの符号なし型に変換します。

# 例

```jldoctest
julia> unsigned(Int16)
UInt16
julia> unsigned(UInt64)
UInt64
```
