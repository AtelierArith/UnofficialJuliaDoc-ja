```julia
format_bytes(bytes; binary=true)
```

指定したバイト数を、人が読みやすい文字列に変換します。

# Arguments

  * `bytes`: 変換するバイト数。
  * `binary=true`: `true` の場合、バイナリ単位（1024 の累乗）でバイト数を表します。`false` の場合は、10 進単位（1000 の累乗）を使用します。

# Returns

`String`: `binary` 引数に応じて、バイナリ単位または 10 進単位で表した、人が読みやすいバイト数の文字列表現。

# Examples

```jldoctest
julia> Base.format_bytes(1024)
"1024 bytes"

julia> Base.format_bytes(10000)
"9.766 KiB"

julia> Base.format_bytes(10000, binary=false)
"10.000 kB"
```
