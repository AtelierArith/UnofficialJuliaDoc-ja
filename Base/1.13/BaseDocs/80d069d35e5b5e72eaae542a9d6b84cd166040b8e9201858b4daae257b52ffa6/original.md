```julia
setglobal!(module::Module, name::Symbol, x, [order::Symbol=:monotonic])
```

Set or change the value of the binding `name` in the module `module` to `x`. No type conversion is performed, so if a type has already been declared for the binding, `x` must be of appropriate type or an error is thrown.

Additionally, an atomic ordering can be specified for this operation, otherwise it defaults to monotonic.

Users will typically access this functionality through the [`setproperty!`](@ref Base.setproperty!) function or corresponding syntax (i.e. `module.name = x`) instead, so this is intended only for very specific use cases.

!!! compat "Julia 1.9"
    This function requires Julia 1.9 or later.


See also [`setproperty!`](@ref Base.setproperty!) and [`getglobal`](@ref)

# Examples

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*\n.*)*"
julia> module M; global a; end;

julia> M.a  # same as `getglobal(M, :a)`
ERROR: UndefVarError: `a` not defined in `M`
Suggestion: add an appropriate import or assignment. This global was declared but not assigned.
Stacktrace:
 [1] getproperty(x::Module, f::Symbol)
   @ Base ./Base_compiler.jl:40
 [2] top-level scope
   @ none:1

julia> setglobal!(M, :a, 1)
1

julia> M.a
1
```
