```julia
humanage(seconds::Integer) -> String
```

`seconds` を、最大の単位を使った簡潔な経過時間文字列に変換します。

```julia-repl
julia> humanage(70)
"1m"

julia> humanage(4000)
"1h"
```
