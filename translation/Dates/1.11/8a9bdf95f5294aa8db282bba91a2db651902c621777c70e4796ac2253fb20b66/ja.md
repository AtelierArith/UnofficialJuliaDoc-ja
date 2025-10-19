```julia
now(::Type{UTC}) -> DateTime
```

ユーザーのシステム時間に対応する `DateTime` をUTC/GMTとして返します。他のタイムゾーンについては、TimeZones.jlパッケージを参照してください。

# 例

```julia
julia> now(UTC)
2023-01-04T10:52:24.864
```
