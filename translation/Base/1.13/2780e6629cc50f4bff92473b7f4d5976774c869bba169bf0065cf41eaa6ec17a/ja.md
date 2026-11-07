```julia
format_bytes(bytes; binary=true)
```

指定したバイト数を、人が読みやすい文字列に変換します。

# Arguments

  * `bytes`: 変換するバイト数。
  * `binary=true`: `true` の場合、バイト数を2進単位（1024の累乗）で表します。`false` の場合は、10進単位（1000の累乗）を使用します。

# Returns

`String`: バイト数を人が読みやすい文字列で表したもの。`binary` 引数に応じて、2進単位または10進単位で表されます。

# Examples

```jldoctest
julia> Base.format_bytes(1024)
"1024 bytes"

julia> Base.format_bytes(10000)
"9.766 KiB"

julia> Base.format_bytes(10000, binary=false)
"10.000 kB"
```
