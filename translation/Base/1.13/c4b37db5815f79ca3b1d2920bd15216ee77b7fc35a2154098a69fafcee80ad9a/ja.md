```julia
ismalformed(c::AbstractChar)::Bool
```

`c`で使用されるエンコーディングに従って、`c`が不正な（非Unicode）データを表す場合は、`true`を返します。`Char`以外の型では、デフォルトで`false`になります。

関連項目: [`show_invalid`](@ref)。
