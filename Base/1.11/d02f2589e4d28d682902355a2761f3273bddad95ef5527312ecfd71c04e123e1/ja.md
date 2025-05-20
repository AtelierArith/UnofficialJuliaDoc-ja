```
@b_str
```

文字列構文を使用して不変のバイト（`UInt8`）ベクターを作成します。

# 例

```jldoctest
julia> v = b"12\x01\x02"
4-element Base.CodeUnits{UInt8, String}:
 0x31
 0x32
 0x01
 0x02

julia> v[2]
0x32
```
