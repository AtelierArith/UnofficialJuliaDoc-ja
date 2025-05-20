```
LoadError(file::AbstractString, line::Int, error)
```

ファイルを [`include`](@ref Base.include) したり、[`require`](@ref Base.require) したり、[`using`](@ref) したりする際にエラーが発生しました。エラーの詳細は `.error` フィールドで確認できます。

!!! compat "Julia 1.7"
    Julia 1.7 以降、`@macroexpand`、`@macroexpand1`、および `macroexpand` によって LoadErrors は発生しなくなりました。

