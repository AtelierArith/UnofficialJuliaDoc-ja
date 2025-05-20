```
Base.@nospecializeinfer function f(args...)
    @nospecialize ...
    ...
end
Base.@nospecializeinfer f(@nospecialize args...) = ...
```

Tells the compiler to infer `f` using the declared types of `@nospecialize`d arguments. This can be used to limit the number of compiler-generated specializations during inference.

# Examples

```julia
julia> f(A::AbstractArray) = g(A)
f (generic function with 1 method)

julia> @noinline Base.@nospecializeinfer g(@nospecialize(A::AbstractArray)) = A[1]
g (generic function with 1 method)

julia> @code_typed f([1.0])
CodeInfo(
1 ─ %1 = invoke Main.g(_2::AbstractArray)::Any
└──      return %1
) => Any
```

In this example, `f` will be inferred for each specific type of `A`, but `g` will only be inferred once with the declared argument type `A::AbstractArray`, meaning that the compiler will not likely see the excessive inference time on it while it can not infer the concrete return type of it. Without the `@nospecializeinfer`, `f([1.0])` would infer the return type of `g` as `Float64`, indicating that inference ran for `g(::Vector{Float64})` despite the prohibition on specialized code generation.

!!! compat "Julia 1.10"
    Using `Base.@nospecializeinfer` requires Julia version 1.10.

