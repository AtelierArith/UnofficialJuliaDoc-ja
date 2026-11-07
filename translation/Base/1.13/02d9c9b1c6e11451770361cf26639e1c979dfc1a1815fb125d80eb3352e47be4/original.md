```julia
@__FUNCTION__
```

Get the innermost enclosing function object.

!!! note
    `@__FUNCTION__` has the same scoping behavior as `return`: when used inside a closure, it refers to the closure and not the outer function. Some macros, including [`@spawn`](@ref Threads.@spawn), [`@async`](@ref), etc., wrap their input in closures. When `@__FUNCTION__` is used within such code, it will refer to the closure created by the macro rather than the enclosing function.


# Examples

`@__FUNCTION__` enables recursive anonymous functions:

```jldoctest
julia> factorial = (n -> n <= 1 ? 1 : n * (@__FUNCTION__)(n - 1));

julia> factorial(5)
120
```

`@__FUNCTION__` can be combined with `nameof` to identify a function's name from within its body:

```jldoctest
julia> bar() = nameof(@__FUNCTION__);

julia> bar()
:bar
```

!!! compat "Julia 1.13"
    This macro requires at least Julia 1.13.

