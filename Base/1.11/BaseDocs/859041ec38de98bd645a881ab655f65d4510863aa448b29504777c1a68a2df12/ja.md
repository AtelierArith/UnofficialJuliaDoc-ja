```
DivideError()
```

整数除算が分母の値が 0 の場合に試みられました。

# 例

```jldoctest
julia> 2/0
Inf

julia> div(2, 0)
ERROR: DivideError: 整数除算エラー
Stacktrace:
[...]
```
