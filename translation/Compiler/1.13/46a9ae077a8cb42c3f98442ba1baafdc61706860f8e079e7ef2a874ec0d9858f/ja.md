```julia
validate_code!(errors::Vector{InvalidCodeError}, mi::MethodInstance,
               c::Union{Nothing,CodeInfo})
```

`mi`を検証し、違反があれば`InvalidCodeError`を`errors`にプッシュして記録します。

`isa(c, CodeInfo)`の場合は、`validate_code!(errors, c)`も呼び出します。`c`は、`mi`に関連付けられた`CodeInfo`インスタンスであると想定します。
