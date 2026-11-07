```julia
transcode(T, src)
```

Unicodeエンコーディング間で文字列データを変換します。`src`は、UTF-XXコード単位の`String`または`Vector{UIntXX}`であり、`XX`は8、16、または32です。`T`は戻り値のエンコーディングを指定します。`String`を指定すると（UTF-8でエンコードされた）`String`が返され、`UIntXX`を指定すると、UTF-`XX`データの`Vector{UIntXX}`が返されます。（整数型にはエイリアスの[`Cwchar_t`](@ref)も使用できます。これは、外部Cライブラリで使われる`wchar_t*`文字列の変換に利用できます。）

入力データを変換先のエンコーディングで妥当に表現できる限り、`transcode`関数は成功します。UTF-XXエンコーディング間の変換では、不正なUnicodeデータであっても常に成功します。

現在サポートされているのは、UTF-8との変換のみです。

# Examples

```jldoctest
julia> str = "αβγ"
"αβγ"

julia> transcode(UInt16, str)
3-element Vector{UInt16}:
 0x03b1
 0x03b2
 0x03b3

julia> transcode(String, transcode(UInt16, str))
"αβγ"
```
