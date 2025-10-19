```julia
OncePerProcess{T}(init::Function)() -> T
```

Calling a `OncePerProcess` object returns a value of type `T` by running the function `initializer` exactly once per process. All concurrent and future calls in the same process will return exactly the same value. This is useful in code that will be precompiled, as it allows setting up caches or other state which won't get serialized.

!!! compat "Julia 1.12"
    This type requires Julia 1.12 or later.


## Example

```jldoctest
julia> const global_state = Base.OncePerProcess{Vector{UInt32}}() do
           println("Making lazy global value...done.")
           return [Libc.rand()]
       end;

julia> (procstate = global_state()) |> typeof
Making lazy global value...done.
Vector{UInt32} (alias for Array{UInt32, 1})

julia> procstate === global_state()
true

julia> procstate === fetch(@async global_state())
true
```
