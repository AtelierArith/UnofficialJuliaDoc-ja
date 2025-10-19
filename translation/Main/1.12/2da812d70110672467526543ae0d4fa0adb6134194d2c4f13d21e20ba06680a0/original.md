```julia
include([mapexpr::Function,] path::AbstractString)
```

Evaluate the contents of the input source file in the global scope of the containing module. Every `Module` (except those defined with `baremodule`) has a private 1-argument definition of `include`, which evaluates the file in that module, for use inside that module. Returns the result of the last evaluated expression of the input file. During including, a task-local include path is set to the directory containing the file. Nested calls to `include` will search relative to that path. This function is typically used to load source interactively, or to combine files in packages that are broken into multiple source files. The argument `path` is normalized using [`normpath`](@ref) which will resolve relative path tokens such as `..` and convert `/` to the appropriate path separator.

The optional first argument `mapexpr` can be used to transform the included code before it is evaluated: for each parsed expression `expr` in `path`, the `include` function actually evaluates `mapexpr(expr)`.  If it is omitted, `mapexpr` defaults to [`identity`](@ref).

Use [`Base.include`](@ref) to evaluate a file into another module.

!!! note
    Julia's syntax lowering recognizes an explicit call to a literal `include` at top-level and inserts an implicit `@Core.latestworld` to make any include'd definitions visible to subsequent code. Note however that this recognition is *syntactic*. I.e. assigning `const myinclude = include` may require and explicit `@Core.latestworld` call after `myinclude`.


!!! compat "Julia 1.5"
    Julia 1.5 is required for passing the `mapexpr` argument.

