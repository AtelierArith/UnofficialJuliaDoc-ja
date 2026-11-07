```julia
is_no_constprop(method::Union{Method,CodeInfo})::Bool
```

`method` が `Base.@constprop :none` として宣言されているか確認してください。
