```julia
Unsigned <: Integer
```

すべての符号なし整数の抽象スーパータイプです。

組み込みの符号なし整数は、接頭辞 `0x` を付けた16進数で表示され、同じ形式で入力できます。

# Examples

```julia
julia> typemax(UInt8)
0xff

julia> Int(0x00d)
13

julia> unsigned(true)
0x0000000000000001
```
