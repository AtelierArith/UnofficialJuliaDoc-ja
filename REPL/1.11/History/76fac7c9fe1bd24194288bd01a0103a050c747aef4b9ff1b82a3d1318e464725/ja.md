```julia
humanage(seconds::Integer) -> String
```

最大の単位を使って、`seconds` を簡潔な年齢文字列に変換します。

```julia-repl
julia> humanage(70)
"1m"

julia> humanage(4000)
"1h"
```
