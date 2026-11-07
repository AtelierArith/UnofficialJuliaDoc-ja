```julia
isoverlong(c::AbstractChar)::Bool
```

`c`が過長なUTF-8シーケンスを表す場合は、`true`を返します。`Char`以外の型では、デフォルトで`false`になります。

[`decode_overlong`](@ref)および[`show_invalid`](@ref)も参照してください。
