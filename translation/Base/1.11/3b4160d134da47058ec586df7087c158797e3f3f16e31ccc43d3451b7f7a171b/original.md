```
Channel{T=Any}(size::Int=0)
```

Constructs a `Channel` with an internal buffer that can hold a maximum of `size` objects of type `T`. [`put!`](@ref) calls on a full channel block until an object is removed with [`take!`](@ref).

`Channel(0)` constructs an unbuffered channel. `put!` blocks until a matching `take!` is called. And vice-versa.

Other constructors:

  * `Channel()`: default constructor, equivalent to `Channel{Any}(0)`
  * `Channel(Inf)`: equivalent to `Channel{Any}(typemax(Int))`
  * `Channel(sz)`: equivalent to `Channel{Any}(sz)`

!!! compat "Julia 1.3"
    The default constructor `Channel()` and default `size=0` were added in Julia 1.3.

