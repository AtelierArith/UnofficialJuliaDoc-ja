```
LoadError(file::AbstractString, line::Int, error)
```

An error occurred while [`include`](@ref Base.include)ing, [`require`](@ref Base.require)ing, or [`using`](@ref) a file. The error specifics should be available in the `.error` field.

!!! compat "Julia 1.7"
    LoadErrors are no longer emitted by `@macroexpand`, `@macroexpand1`, and `macroexpand` as of Julia 1.7.

