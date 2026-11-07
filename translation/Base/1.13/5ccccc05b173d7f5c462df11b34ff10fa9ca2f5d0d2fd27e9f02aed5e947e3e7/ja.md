```julia
isoverlong(c::AbstractChar)::Bool
```

`c`が過長なUTF-8シーケンスを表す場合は、`true`を返します。`Char`以外の型の場合は、`false`がデフォルトです。

[`decode_overlong`](@ref)および[`show_invalid`](@ref)も参照してください。
