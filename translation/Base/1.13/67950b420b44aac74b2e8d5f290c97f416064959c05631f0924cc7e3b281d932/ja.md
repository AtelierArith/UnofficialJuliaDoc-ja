```julia
transcode(T, src)
```

Unicode エンコーディング間で文字列データを変換します。`src` は、UTF-XX コード単位の `String` または `Vector{UIntXX}` であり、`XX` は 8、16、または 32 です。`T` は戻り値のエンコーディングを指定します。`String` は（UTF-8 でエンコードされた）`String` を返し、`UIntXX` は UTF-`XX` データの `Vector{UIntXX}` を返します。（外部 C ライブラリで使用される `wchar_t*` 文字列を変換する場合は、整数型としてエイリアス [`Cwchar_t`](@ref) も使用できます。）

`transcode` 関数は、入力データを変換先のエンコーディングで妥当に表現できる限り成功します。UTF-XX エンコーディング間の変換では、不正な Unicode データであっても常に成功します。

現在サポートされているのは、UTF-8 との変換のみです。

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
