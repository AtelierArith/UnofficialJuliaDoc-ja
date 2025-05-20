```
@invoke f(arg::T, ...; kwargs...)
```

Provides a convenient way to call [`invoke`](@ref) by expanding `@invoke f(arg1::T1, arg2::T2; kwargs...)` to `invoke(f, Tuple{T1,T2}, arg1, arg2; kwargs...)`. When an argument's type annotation is omitted, it's replaced with `Core.Typeof` that argument. To invoke a method where an argument is untyped or explicitly typed as `Any`, annotate the argument with `::Any`.

It also supports the following syntax:

  * `@invoke (x::X).f` expands to `invoke(getproperty, Tuple{X,Symbol}, x, :f)`
  * `@invoke (x::X).f = v::V` expands to `invoke(setproperty!, Tuple{X,Symbol,V}, x, :f, v)`
  * `@invoke (xs::Xs)[i::I]` expands to `invoke(getindex, Tuple{Xs,I}, xs, i)`
  * `@invoke (xs::Xs)[i::I] = v::V` expands to `invoke(setindex!, Tuple{Xs,V,I}, xs, v, i)`

# Examples

```jldoctest
julia> @macroexpand @invoke f(x::T, y)
:(Core.invoke(f, Tuple{T, Core.Typeof(y)}, x, y))

julia> @invoke 420::Integer % Unsigned
0x00000000000001a4

julia> @macroexpand @invoke (x::X).f
:(Core.invoke(Base.getproperty, Tuple{X, Core.Typeof(:f)}, x, :f))

julia> @macroexpand @invoke (x::X).f = v::V
:(Core.invoke(Base.setproperty!, Tuple{X, Core.Typeof(:f), V}, x, :f, v))

julia> @macroexpand @invoke (xs::Xs)[i::I]
:(Core.invoke(Base.getindex, Tuple{Xs, I}, xs, i))

julia> @macroexpand @invoke (xs::Xs)[i::I] = v::V
:(Core.invoke(Base.setindex!, Tuple{Xs, V, I}, xs, v, i))
```

!!! compat "Julia 1.7"
    This macro requires Julia 1.7 or later.


!!! compat "Julia 1.9"
    This macro is exported as of Julia 1.9.


!!! compat "Julia 1.10"
    The additional syntax is supported as of Julia 1.10.

