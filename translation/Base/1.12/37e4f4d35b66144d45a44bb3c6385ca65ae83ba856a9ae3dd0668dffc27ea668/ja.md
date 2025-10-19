```julia
signed(T::Integer)
```

整数のビットタイプを同じサイズの符号付きタイプに変換します。

# 例

```jldoctest
julia> signed(UInt16)
Int16
julia> signed(UInt64)
Int64
```
