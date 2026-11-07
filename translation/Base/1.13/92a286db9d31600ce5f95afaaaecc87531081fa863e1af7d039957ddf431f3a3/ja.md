```julia
unsigned(T::Integer)
```

整数ビット型を、同じサイズの符号なし型に変換します。

# Examples

```jldoctest
julia> unsigned(Int16)
UInt16
julia> unsigned(UInt64)
UInt64
```
