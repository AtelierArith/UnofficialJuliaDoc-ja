```julia
DivideError()
```

整数除算が0の分母値で試みられました。

# 例

```jldoctest
julia> 2/0
Inf

julia> div(2, 0)
ERROR: DivideError: 整数除算エラー
Stacktrace:
[...]
```
