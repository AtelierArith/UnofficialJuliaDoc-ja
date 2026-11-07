```julia
sizeof(str::AbstractString)
```

`str` のバイト単位でのサイズ。`str` のコード単位数に、`str` の1コード単位あたりのバイト数を掛けた値です。

# Examples

```jldoctest
julia> sizeof("")
0

julia> sizeof("∀")
3
```
