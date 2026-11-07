```julia
signed(T::Integer)
```

整数ビット型を、同じサイズの符号付き型に変換します。

# Examples

```jldoctest
julia> signed(UInt16)
Int16
julia> signed(UInt64)
Int64
```
