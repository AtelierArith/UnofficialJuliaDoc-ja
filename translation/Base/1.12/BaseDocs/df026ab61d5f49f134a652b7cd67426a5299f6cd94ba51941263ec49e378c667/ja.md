```julia
LoadError(file::AbstractString, line::Int, error)
```

ファイルを[`include`](@ref Base.include)したり、[`require`](@ref Base.require)したり、[`using`](@ref)したりする際にエラーが発生しました。エラーの詳細は`.error`フィールドにあります。

!!! compat "Julia 1.7"
    Julia 1.7以降、`@macroexpand`、`@macroexpand1`、および`macroexpand`によってLoadErrorsは発生しなくなりました。

