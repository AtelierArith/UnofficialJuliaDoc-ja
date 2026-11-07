```julia
humanage(seconds::Integer) -> String
```

Convert `seconds` into a compact age string with largest unit.

```julia-repl
julia> humanage(70)
"1m"

julia> humanage(4000)
"1h"
```
