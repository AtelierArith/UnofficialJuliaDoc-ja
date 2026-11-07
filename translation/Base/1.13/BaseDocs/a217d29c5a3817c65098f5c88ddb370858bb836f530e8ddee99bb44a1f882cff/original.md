```julia
declare_const(module::Module, name::Symbol, [x])
```

Create or replace the constant `name` in `module` with the new value `x`.  When replacing, `x` does not need to have the same type as the original constant.

When `x` is not given, `name` becomes an undefined constant; it cannot be read or written to, but can be redefined.

Unlike the syntax `const`, calling this function does not insert `Core.@latestworld` to update the world age of the current frame:

```julia
julia> begin
           const x = 1
           println(x)
           const x = 2
           println(x)
           Core.declare_const(Main, :x, 3)
           println(x)
           Core.@latestworld
           println(x)
       end
1
2
2
3
```

!!! compat "Julia 1.12"
    This function requires Julia 1.12 or later.  Redefining constants on earlier versions of Julia is unpredictable.


See also [`const`](@ref).
