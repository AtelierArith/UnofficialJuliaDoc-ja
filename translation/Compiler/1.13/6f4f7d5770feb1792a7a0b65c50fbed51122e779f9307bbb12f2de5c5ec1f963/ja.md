```julia
is_aggressive_constprop(method::Union{Method,CodeInfo})::Bool
```

`method` が `Base.@constprop :aggressive` として宣言されているか確認してください。
