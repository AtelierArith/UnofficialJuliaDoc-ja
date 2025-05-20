```
Unsigned <: Integer
```

すべての符号なし整数のための抽象スーパタイプ。

組み込みの符号なし整数は16進数で表示され、接頭辞 `0x` が付いており、同じ方法で入力できます。

# 例

```
julia> typemax(UInt8)
0xff

julia> Int(0x00d)
13

julia> unsigned(true)
0x0000000000000001
```
