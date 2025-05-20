```
transcode(T, src)
```

文字列データをUnicodeエンコーディング間で変換します。`src`は`String`またはUTF-XXコードユニットの`Vector{UIntXX}`であり、ここで`XX`は8、16、または32です。`T`は戻り値のエンコーディングを示します：`String`は（UTF-8エンコードされた）`String`を返し、`UIntXX`はUTF-`XX`データの`Vector{UIntXX}`を返します。（外部Cライブラリによって使用される`wchar_t*`文字列を変換するために、整数型として[`Cwchar_t`](@ref)も使用できます。）

`transcode`関数は、入力データがターゲットエンコーディングで合理的に表現できる限り成功します。無効なUnicodeデータに対しても、UTF-XXエンコーディング間の変換は常に成功します。

現在、UTF-8への/からの変換のみがサポートされています。

# 例

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
