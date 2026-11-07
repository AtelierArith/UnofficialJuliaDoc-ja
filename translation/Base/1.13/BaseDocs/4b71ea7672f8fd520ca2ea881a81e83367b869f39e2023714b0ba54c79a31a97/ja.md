```julia
LoadError(file::AbstractString, line::Int, error)
```

ファイルの[`include`](@ref Base.include)、[`require`](@ref Base.require)、または[`using`](@ref)中にエラーが発生しました。エラーの詳細は`.error`フィールドに記載されています。

!!! compat "Julia 1.7"
    Julia 1.7以降、`@macroexpand`、`@macroexpand1`、`macroexpand`ではLoadErrorsは発生しなくなりました。

