```
sizeof(str::AbstractString)
```

文字列 `str` のサイズ（バイト単位）。`str` のコードユニットの数に `str` の1つのコードユニットのサイズ（バイト単位）を掛けたものに等しい。

# 例

```jldoctest
julia> sizeof("")
0

julia> sizeof("∀")
3
```
