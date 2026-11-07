```julia
validargs(::Type{<:TimeType}, args...)::Union{ArgumentError, Nothing}
```

与えられた引数が、指定された型に対する有効な入力かどうかを判定します。成功した場合は`ArgumentError`を返し、そうでない場合は[`nothing`](@ref)を返します。
