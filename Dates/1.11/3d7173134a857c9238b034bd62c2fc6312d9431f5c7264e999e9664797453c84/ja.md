```
validargs(::Type{<:TimeType}, args...) -> Union{ArgumentError, Nothing}
```

与えられた引数が指定された型の有効な入力であるかどうかを判断します。成功した場合は、`ArgumentError` または [`nothing`](@ref) を返します。
