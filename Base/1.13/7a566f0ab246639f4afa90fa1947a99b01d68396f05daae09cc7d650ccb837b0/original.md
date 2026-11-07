```julia
OncePerTask{T}(init::Function)() -> T
```

Calling a `OncePerTask` object returns a value of type `T` by running the function `initializer` exactly once per Task. All future calls in the same Task will return exactly the same value.

See also: [`task_local_storage`](@ref).

!!! compat "Julia 1.12"
    This type requires Julia 1.12 or later.


## Example

```jldoctest
julia> const task_state = Base.OncePerTask{Vector{UInt32}}() do
           println("Making lazy task value...done.")
           return [Libc.rand()]
       end;

julia> (taskvec = task_state()) |> typeof
Making lazy task value...done.
Vector{UInt32} (alias for Array{UInt32, 1})

julia> taskvec === task_state()
true

julia> taskvec === fetch(@async task_state())
Making lazy task value...done.
false
```
