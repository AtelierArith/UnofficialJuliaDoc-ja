```julia
decode_overlong(c::AbstractChar)::Integer
```

[`isoverlong(c)`](@ref) が `true` の場合、`decode_overlong(c)` は `c` の Unicode コードポイント値を返します。オーバーロングエンコーディングをサポートする `AbstractChar` の実装では、`Base.decode_overlong` を実装する必要があります。
