```
@deprecate old new [export_old=true]
```

Deprecate method `old` and specify the replacement call `new`, defining a new method `old` with the specified signature in the process.

To prevent `old` from being exported, set `export_old` to `false`.

See also [`Base.depwarn()`](@ref).

!!! compat "Julia 1.5"
    As of Julia 1.5, functions defined by `@deprecate` do not print warning when `julia` is run without the `--depwarn=yes` flag set, as the default value of `--depwarn` option is `no`.  The warnings are printed from tests run by `Pkg.test()`.


# Examples

```jldoctest
julia> @deprecate old(x) new(x)
old (generic function with 1 method)

julia> @deprecate old(x) new(x) false
old (generic function with 1 method)
```

Calls to `@deprecate` without explicit type-annotations will define deprecated methods accepting any number of positional and keyword arguments of type `Any`.

!!! compat "Julia 1.9"
    Keyword arguments are forwarded when there is no explicit type annotation as of Julia 1.9. For older versions, you can manually forward positional and keyword arguments by doing `@deprecate old(args...; kwargs...) new(args...; kwargs...)`.


To restrict deprecation to a specific signature, annotate the arguments of `old`. For example,

```jldoctest; filter = r"@ .*"a
julia> new(x::Int) = x;

julia> new(x::Float64) = 2x;

julia> @deprecate old(x::Int) new(x);

julia> methods(old)
# 1 method for generic function "old" from Main:
 [1] old(x::Int64)
     @ deprecated.jl:94
```

will define and deprecate a method `old(x::Int)` that mirrors `new(x::Int)` but will not define nor deprecate the method `old(x::Float64)`.
