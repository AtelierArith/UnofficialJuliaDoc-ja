```julia
@spawnat p expr
```

Create a closure around an expression and run the closure asynchronously on process `p`. Return a [`Future`](@ref) to the result.

If `p` is the quoted literal symbol `:any`, then the system will pick a processor to use automatically. Using `:any` will not apply any form of load-balancing, consider using a [`WorkerPool`](@ref) and [`remotecall(f, ::WorkerPool)`](@ref) if you need load-balancing.

# Examples

```julia-repl
julia> addprocs(3);

julia> f = @spawnat 2 myid()
Future(2, 1, 3, nothing)

julia> fetch(f)
2

julia> f = @spawnat :any myid()
Future(3, 1, 7, nothing)

julia> fetch(f)
3
```

!!! compat "Julia 1.3"
    The `:any` argument is available as of Julia 1.3.

