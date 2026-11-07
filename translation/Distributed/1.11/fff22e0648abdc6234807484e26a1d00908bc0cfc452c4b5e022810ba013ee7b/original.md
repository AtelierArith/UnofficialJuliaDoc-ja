```julia
@spawn expr
```

Create a closure around an expression and run it on an automatically-chosen process, returning a [`Future`](@ref) to the result. This macro is deprecated; `@spawnat :any expr` should be used instead.

# Examples

```julia-repl
julia> addprocs(3);

julia> f = @spawn myid()
Future(2, 1, 5, nothing)

julia> fetch(f)
2

julia> f = @spawn myid()
Future(3, 1, 7, nothing)

julia> fetch(f)
3
```

!!! compat "Julia 1.3"
    As of Julia 1.3 this macro is deprecated. Use `@spawnat :any` instead.

