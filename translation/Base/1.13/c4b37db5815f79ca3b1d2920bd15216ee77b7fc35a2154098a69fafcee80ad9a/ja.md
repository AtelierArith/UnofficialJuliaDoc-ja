```julia
ismalformed(c::AbstractChar)::Bool
```

`c`で使用されるエンコーディングに従って、`c`が不正な（Unicodeではない）データを表す場合に、`true`を返します。`Char`以外の型では、デフォルトで`false`になります。

[`show_invalid`](@ref)も参照してください。
