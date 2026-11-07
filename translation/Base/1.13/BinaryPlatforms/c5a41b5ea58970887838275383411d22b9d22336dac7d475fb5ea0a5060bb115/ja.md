```julia
compare_default(a::String, b::String, a_requested::Bool, b_requested::Bool)
```

`a == b` にフォールバックするデフォルトの比較戦略。これは、`a` と `b` の両方がこの戦略を要求した場合に限って発生します。他の戦略はどれも、この戦略より優先されるためです。
